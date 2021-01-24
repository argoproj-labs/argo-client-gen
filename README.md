# Client Libraries

This page contains an overview of the client libraries for using the Argo API from various programming languages.

* [Officially-supported client libraries](#officially-supported-client-libraries)
* [Community-maintained client libraries](#community-maintained-client-libraries)

To write applications using the  REST API, you do not need to implement the API calls and request/response types yourself. You can use a client library for the programming language you are using.

 Client libraries often handle common tasks such as authentication for you. 

## Officially-supported client libraries

The following client libraries are officially maintained by the Argo team.

| Language | Client Library | Examples/Docs |
|----------|----------------|---------------|
| Golang   | [apiclient.go](https://github.com/argoproj/argo/blob/master/pkg/apiclient/apiclient.go) | [Example](https://github.com/argoproj/argo/blob/master/cmd/argo/commands/submit.go)
| Java     | [argo-client-java](https://github.com/argoproj-labs/argo-client-java) | |

## Community-maintained client libraries

The following client libraries are provided and maintained by their authors, not the Argo team.

| Language | Client Library | Examples/Docs |
|----------|----------------|---------------|
| Python   | [argo-client-python](https://github.com/argoproj-labs/argo-client-python) | Lower-level/API focus | 
| Python   | [Couler](https://github.com/couler-proj/couler) | Machine Learning focussed |



