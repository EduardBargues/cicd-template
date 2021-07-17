# CICD-TEMPLATE

This repo is meant to provide an initial template for teams so they can fork it and start working on it.

## Features this repo provides

Out of the box, the following features are provided:

- **development**

  A (dummy) service is included in the _src_ folder. The folder includes a functional serverless web-api developed in dotnet-core-3.1 with unit-tests and a '_/diagnostics_' endpoint that returns '_diagnostics-ok_' when called.
  A folder called "docker" is located in the root of the repo. Inside, you'll find 2 dockerfiles to create.artifact and run e2e tests locally. Both dockerfiles are meant to help you better develop your api localy.

### Up-coming features

- **continuous-integration**

  The repo provides scripts (folder _scripts_) and work-flow definitions(folder _.github.workflows_) that will trigger checks during pull requests. The workflow definition can be found at _pull-requests-workflow_. This definition includes: ensuring that all commits follow _conventional-commits_ and contain a _jira_ ticket, running _unit-tests_, creating and uploading temporary artifacts to an s3 bucket from branch and deploying the infrastructure into a _dev-aws-account_.

- **continuous-delivery**

  Once a pull request is merged into the main branch, the workflow _after-merge-workflow_ is launched. Here, the workflow _semantically versions_ the repository, tags your merge commit with the new semver, creates and uploads semver artifacts, and deploys them to an aws-account automatically.

- **continuous-deployment**

  In the same _after-merge-workflow_, you can find a deployment step to a _dev-aws-account_ as a continuous-deployment example. Change it to your team needs.

- **End to end testing**

  A folder called tests holds some e2e tests that represent how your client would call the api once deployed.

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
- Execute the following commands in your terminal:
  > **cd cicd-template/** #move inside the repository
  > **chmod +x ./docker/\*.sh** #execution permissions to the .sh files
  > **./docker/run-container-locally.sh** # build aspnetcore image and run webapi in http://localhost:5000/diagnostics
  > **./docker/run-e2e-locally.sh** # in a new terminal! => run e2e tests against the previous container (port 5000)

## Who/How to contact

- Eduard Bargués
  · email: eduardbargues@gmail.com
  · linkedin: https://www.linkedin.com/in/eduardbargues/
  · github-profile: https://github.com/EduardBargues
- Open an issue in the same repository: https://github.com/EduardBargues/cicd-template/issues/new

## How to contribute?

- Open a pull request against the main branch: https://github.com/EduardBargues/cicd-template/pulls
