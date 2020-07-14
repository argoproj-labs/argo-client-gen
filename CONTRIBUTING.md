# Contributing

## Java

How to publish the Java code:

```
export ARGO_TOKEN=$(argo auth token)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
make clean publish-java GIT_BRANCH=release-2.9 VERSION=v2.9.2   
```
