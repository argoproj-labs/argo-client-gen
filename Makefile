GIT_ORG    := argoproj
GIT_BRANCH := $(shell git rev-parse --abbrev-ref=loose HEAD | sed 's/heads\///')
VERSION    := HEAD

# VERSION as GIT_BRANCH must be different
ifneq ($(VERSION),$(GIT_BRANCH))

SWAGGER    := https://raw.githubusercontent.com/$(GIT_ORG)/argo/$(VERSION)/api/openapi-spec/swagger.json

clients: java

.PHONY: clean
clean:
	rm -Rf dist

dist/swagger.json:
	curl -L -o dist/swagger.json $(SWAGGER)

dist/openapi-generator-cli.jar:
	mkdir -p dist
	curl -L -o dist/openapi-generator-cli.jar https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/4.2.3/openapi-generator-cli-4.2.3.jar

# java client

ifeq ($(VERSION),HEAD)
JAVA_CLIENT_VERSION := 1-SNAPSHOT
else
JAVA_CLIENT_VERSION := $(subst v,,$(VERSION))
endif
JAVA_CLIENT_JAR     := $(HOME)/.m2/repository/io/argoproj/workflow/argo-client-java/$(JAVA_CLIENT_VERSION)/argo-client-java-$(JAVA_CLIENT_VERSION).jar

dist/java.swagger.json: dist/swagger.json
	cat dist/swagger.json | sed 's/io.argoproj.workflow.v1alpha1.//' | sed 's/io.k8s.api.core.v1.//'> dist/java.swagger.json

.PHONY: java
java: $(JAVA_CLIENT_JAR)

$(JAVA_CLIENT_JAR): dist/openapi-generator-cli.jar dist/java.swagger.json
	git submodule update --init java
	cd java && git checkout -b $(GIT_BRANCH) || git checkout $(GIT_BRANCH)
	rm -Rf java/*
	java \
		-jar dist/openapi-generator-cli.jar \
		generate \
		-i dist/java.swagger.json \
		-g java \
		-o java \
		-p hideGenerationTimestamp=true \
		-p dateLibrary=joda \
		--api-package io.argoproj.workflow.apis \
		--invoker-package io.argoproj.workflow \
		--model-package io.argoproj.workflow.models \
		--group-id io.argoproj.workflow \
		--artifact-id argo-client-java \
		--artifact-version $(JAVA_CLIENT_VERSION) \
		--import-mappings Time=org.joda.time.DateTime \
		--import-mappings Affinity=io.kubernetes.client.models.V1Affinity \
		--import-mappings ConfigMapKeySelector=io.kubernetes.client.models.V1ConfigMapKeySelector \
		--import-mappings Container=io.kubernetes.client.models.V1Container \
		--import-mappings ContainerPort=io.kubernetes.client.models.V1ContainerPort \
		--import-mappings EnvFromSource=io.kubernetes.client.models.V1EnvFromSource \
		--import-mappings EnvVar=io.kubernetes.client.models.V1EnvVar \
		--import-mappings HostAlias=io.kubernetes.client.models.V1HostAlias \
		--import-mappings Lifecycle=io.kubernetes.client.models.V1Lifecycle \
		--import-mappings ListMeta=io.kubernetes.client.models.V1ListMeta \
		--import-mappings LocalObjectReference=io.kubernetes.client.models.V1LocalObjectReference \
		--import-mappings ObjectMeta=io.kubernetes.client.models.V1ObjectMeta \
		--import-mappings ObjectReference=io.kubernetes.client.models.V1ObjectReference \
		--import-mappings PersistentVolumeClaim=io.kubernetes.client.models.V1PersistentVolumeClaim \
		--import-mappings PodDNSConfig=io.kubernetes.client.models.V1PodDNSConfig \
		--import-mappings PodSecurityContext=io.kubernetes.client.models.V1PodSecurityContext \
		--import-mappings Probe=io.kubernetes.client.models.V1Probe \
		--import-mappings ResourceRequirements=io.kubernetes.client.models.V1ResourceRequirements \
		--import-mappings SecretKeySelector=io.kubernetes.client.models.V1SecretKeySelector \
		--import-mappings SecurityContext=io.kubernetes.client.models.V1SecurityContext \
		--import-mappings Toleration=io.kubernetes.client.models.V1Toleration \
		--import-mappings Volume=io.kubernetes.client.models.V1Volume \
		--import-mappings VolumeDevice=io.kubernetes.client.models.V1VolumeDevice \
		--import-mappings VolumeMount=io.kubernetes.client.models.V1VolumeMount \
	# add the io.kubernetes:java-client to the deps
	cd java && sed 's/<dependencies>/<dependencies><dependency><groupId>io.kubernetes<\/groupId><artifactId>client-java<\/artifactId><version>5.0.0<\/version><\/dependency>/g' pom.xml > tmp && mv tmp pom.xml
    # I don't like these tests
	rm -Rf java/src/test
	cd java && mvn package -Dmaven.javadoc.skip
	cd java && git add .
	cd java && git diff --exit-code || git commit -m 'Updated to $(JAVA_CLIENT_VERSION)'
ifneq ($(VERSION),HEAD)
	git tag -f $(VERSION)
endif
	cd java && mvn install -DskipTests -Dmaven.javadoc.skip
	git add java

.PHONY: test-java
test-java: java-test/target/ok

java-test/target/ok: $(JAVA_CLIENT_JAR)
	cd java-test && mvn versions:set -DnewVersion=$(JAVA_CLIENT_VERSION) verify
	touch java-test/target/ok

.PHONY: publish-java
publish-java: test-java
	# https://help.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-apache-maven-for-use-with-github-packages
	cd java && mvn deploy -DskipTests -Dmaven.javadoc.skip -DaltDeploymentRepository=github::default::https://maven.pkg.github.com/argoproj-labs/argo-client-java
	cd java && git push origin $(GIT_BRANCH)
ifneq ($(VERSION),HEAD)
	cd java && git push origin $(VERSION)
endif

endif