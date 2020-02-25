# Client Libraries

This page contains an overview of the client libraries for using the Argo API from various programming languages.

* [Officially-supported client libraries](#officially-supported-client-libraries)
* [Community-maintained client libraries](#community-maintained-client-libraries)

To write applications using the  REST API, you do not need to implement the API calls and request/response types yourself. You can use a client library for the programming language you are using.

 Client libraries often handle common tasks such as authentication for you. 

## Officially-supported client libraries

The following Kubernetes API client libraries are provided and maintained by their authors, not the Argo team.

| Language | Client Library | Example/Docs |
|-|-|
| Golang | [apiclient.go](../pkg/apiclient/apiclient.go) | [Example](../cmd/argo/commands/submit.go)
| Java | [argo-java-client](../argo-client-java) | [Example](java-test) |

# Community-maintained client libraries

| Language | Client Library | Example/Docs |
|-|-|
| Python | [argo-client-python](https://github.com/CermakM/argo-client-python) | | 
## Java

```
cd ~/go/src/github.com/argoproj/argo
eval $(make env)
cd -
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
git checkout release-2.5
make publish-java VERSION=v2.5.0 GIT_ORG=alexec  
```