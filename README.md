# CICD-TEMPLATE

This repo is meant to provide an initial template for teams so they can fork it and start working on it. Plug and run solution that holds a web api supported by a lambda and developed in aspnetcore 3.1. Useful for teams that look for a functional solution that requires minimum configuration.

- WebApi developed in C# and AspNetCore 3.1 (supported by a lambda).
- Infrastructure as Code using Terraform 1.x.
- End to end tests developed in NodeJs with Jest.
- Docker images are used to be able to run the web api locally without installing anything.

## Features this repo provides

Out of the box, the following features are provided:

- **development**

  A (dummy) service is included in the _src_ folder. The folder includes a functional serverless web-api developed in dotnet-core-3.1 with unit-tests and a '_/diagnostics_' endpoint that returns '_diagnostics-ok_' when called.
  A folder called "docker" is located in the root of the repo. Inside, you'll find 2 dockerfiles to create artifact and run e2e tests locally. Both dockerfiles are meant to help you better develop your api locally.

- **continuous-integration**

  The repo provides a _scripts_ and _.github/workflows_ folders out of the box with all the necessary scripts and workflows. This definition includes:

  - ensuring that all commits in a pull request follow _conventional-commits_.
  - _unit-tests_ pass.
  - creates and uploads branch artifacts to an s3 bucket from branch
  - deploys the infrastructure into an aws-account.
  - runs e2e tests.
  - runs performance tests.

- **continuous-delivery/deployment**

  Once a pull request is merged into the **main** branch, the workflow _after-merge-workflow_ is launched. Here, the workflow

  - _semantically versions_ the repository, and tags your merge commit with the new version.
  - It also creates and uploads semver artifacts.
  - deploys to an aws-account automatically.

- **End to end testing**

  A folder called _tests_ holds some e2e tests that represent how your client would call the api once deployed. Those tests can be run locally using the scripts inside the _docker_ folder. Include capability to run e2e tests against an already deployed api in a aws account.

- **Performance e2e testing**

  A folder called _tests_ holds some _performance_ tests as a dotnet core 3.1 console application that "attacks" your deployed API and computes the average response time.

### Up-coming features

- **manual-deployment**

  There is also a workflow called _deploy-workflow_ that allows you to manually deploy a specific service and version to an aws-account by introducing the required inputs.

- **manual-infrastructure-destruction**

  There is a workflow called _destroy-workflow_ that will erase your infrastructure in the provided aws account. Use it with caution ;) ...

- **multi-environment configuration**

  There are (at this point) two _main_ branches:

  1. **main**: considered as main. Where all the CI/CD takes place.

  2. **configuration**: this branch is used as a centralized place to configure the service along all the environments and aws accounts.

## How to set it up

This repository is (meant to be) provided as a **_self-contained_** and **_plug-and-run_** solution. Nothing external is required to make it work.
To start working on your own solution follow those steps:

- Fork the repo to create your own.
- Clone your new repo and set your root inside the folder.
- Execute the following commands in your terminal to have the webapi running locally:

  > **cd cicd-template/** #move inside the repository

  > **chmod +x ./docker/\*.sh** #execution permissions to the .sh files

  > **./docker/run-container-locally.sh** # build aspnetcore image and run webapi in http://localhost:5000/diagnostics

  > **./docker/run-e2e-locally.sh** # in a new terminal! => run e2e tests against the previous container (port 5000)

- Setup the following secrets to your (new) repository:
  - AWS_ACCESS_KEY: Access key id of the github user.
  - AWS_SECRET_KEY: Secret key of the github user.
  - AWS_ACCOUNT_ID: Aws account id.
  - AWS_REGION: Aws region name.
  - BUCKET_NAME: Name of the s3 bucket where the artifacts, configurations, and terraform state files will be stored.

## Who/How to contact

- Eduard Bargués
  · email: eduardbargues@gmail.com
  · linkedin: https://www.linkedin.com/in/eduardbargues/
  · github-profile: https://github.com/EduardBargues
- Open an issue in the same repository: https://github.com/EduardBargues/cicd-template/issues/new

## How to contribute?

- Open a pull request against the main branch: https://github.com/EduardBargues/cicd-template/pulls
