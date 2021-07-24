# CICD-TEMPLATE

This repo is meant to provide an initial template for teams so they can fork it and start working on it. Plug and run solution that holds a web api supported by a lambda and developed in aspnetcore 3.1. Useful for teams that look for a functional solution that requires minimum configuration.

- Lambda (as a WebApi) developed in C# and AspNetCore 3.1.
- Lambda developed in NodeJs.
- Lambda developed in Python.
- API with 3 resources (each one pointing to a different lambda).
- Infrastructure as Code using Terraform 1.x.
- End to end tests developed in NodeJs with Jest.
- Docker images are used to be able to run the web api locally without installing anything.

## Features this repo provides

Out of the box, the following features are provided:

- **development**

  A (dummy) application is included in the _src_ folder. The folder includes a functional serverless api supported by 4 lambdas. Lambdas are developed in dotnet-core-3.1, nodejs, and python. In the same folder, some unit tests are included. A folder called "docker" is located in the root of the repo. Inside, you'll find 2 dockerfiles to create artifact and run e2e tests locally for the dotnet-web-api application. Both dockerfiles are meant to help you better develop your api locally.

- **continuous-integration**

  The repo provides a _scripts_ and _.github/workflows_ folders out of the box with all the necessary scripts and workflows. This definition includes:

  - ensuring that all commits in a pull request follow [conventional-commits](https://www.conventionalcommits.org/en/v1.0.0/).
  - _unit-tests_ pass.
  - creates and uploads branch artifacts to an s3 bucket.
  - deploys the infrastructure into an aws-account.
  - runs e2e tests.

- **continuous-delivery/deployment**

  Once a pull request is merged into the **main** branch, the workflow _after-merge-workflow_ is launched. Here, the workflow

  - [semantically versions](https://semver.org/) the repository, and tags your merge commit with the new version.
  - It also creates and uploads semver artifacts.
  - deploys to an aws-account automatically.
  - runs performance tests.

- **End to end testing**

  A folder called _tests_ holds some e2e tests that represent how your client would call the api once deployed. Allows to run e2e tests against an already deployed api in a aws account.

- **Performance e2e testing**

  A folder called _tests_ holds some _performance_ tests as a dotnet core 3.1 console application that "attacks" your deployed API and computes the average response time for all its endpoints.

- **clean-up infra after pull request**

  A workflow called _pull-request-closed-workflow_ will be executed after a pull request is closed (merged or declined). This will ensure no residual infrastructure is left in your AWS account. Good way to avoid extra charge from Amazon :) ...

- **manual-infrastructure-destruction**

  There is a workflow called _destroy-workflow_ that will erase your infrastructure in the provided aws account. Use it with caution ;) ...

- **manual-deployment/configuration**

  Check out the _configuration_ branch.

## How to set it up

This repository is (meant to be) provided as a **_self-contained_** and **_plug-and-run_** solution. Nothing external is required to make it work.
To start working on your own solution follow those steps:

- Fork(or clone) the repo to create your own.
- Execute the following commands in your terminal to have the dotnet webapi running locally:

  > **cd cicd-template/** #move inside the repository

  > **chmod +x ./docker/\*.sh** #execution permissions to the .sh files

  > **./docker/run-container-locally.sh** # build aspnetcore image and run webapi in http://localhost:5000/dotnet

- Setup the following secrets to your (new) repository:

  - AWS_ACCESS_KEY: Access key id of the github user.
  - AWS_SECRET_KEY: Secret key of the github user.
  - AWS_ACCOUNT_ID: Aws account id.
  - AWS_REGION: Aws region name.
  - BUCKET_NAME: Name of the s3 bucket where the artifacts, configurations, and terraform state files will be stored.

- Create a pull request from a new branch to the main branch.

  - This will trigger the continuous-integration workflow.
  - Take into account that all steps in that workflow are conditionally activated based on the folders that have been modified during the pull request.

- Once the pull request is merged to the main branch the continuous-deployment workflow will be activated.

## Who/How to contact

- Eduard Bargués
  - email: eduardbargues@gmail.com
  - linkedin: https://www.linkedin.com/in/eduardbargues/
  - github-profile: https://github.com/EduardBargues
- Open an issue in the same repository: https://github.com/EduardBargues/cicd-template/issues/new

## How to contribute?

- Open a pull request against the main branch: https://github.com/EduardBargues/cicd-template/pulls
