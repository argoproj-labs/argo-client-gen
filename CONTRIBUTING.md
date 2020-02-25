# Contributing

## Java

How to publish the Java code:

```
cd ~/go/src/github.com/argoproj/argo
eval $(make env)
cd -
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
git checkout release-2.5
make publish-java VERSION=v2.5.0 GIT_ORG=alexec  
```
