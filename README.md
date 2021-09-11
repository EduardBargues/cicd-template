# CICD-TEMPLATE

This repo is meant to provide an initial template for teams so they can fork it and start working on it. Plug and run solution that holds an API supported by an [API-gateway](https://aws.amazon.com/api-gateway/) developed in dotnet core 3.1, [NodeJs](https://nodejs.org/en/) and [Python](https://www.python.org/). Useful for teams that look for a functional solution that requires minimum configuration.

- [Lambda](https://aws.amazon.com/lambda/) (as a WebApi) developed in [C#](https://docs.microsoft.com/en-us/dotnet/csharp/) and [AspNetCore](https://docs.microsoft.com/en-us/aspnet/core/?view=aspnetcore-5.0) 3.1.
- [Lambda](https://aws.amazon.com/lambda/) developed in [C#](https://docs.microsoft.com/en-us/dotnet/csharp/) and dotnet core 3.1.
- [Lambda](https://aws.amazon.com/lambda/) developed in [NodeJs](https://nodejs.org/en/).
- [Lambda](https://aws.amazon.com/lambda/) developed in [Python](https://www.python.org/).
- [ECS](https://www.docker.com/) Service supported by [Fargate](https://aws.amazon.com/fargate/) developed with [NodeJs](https://nodejs.org/en/).
- API with 5 resources (each one pointing to a different service, [Lambda](https://aws.amazon.com/lambda/) or [Fargate](https://aws.amazon.com/fargate/)).
- Infrastructure as Code using [Terraform](https://www.terraform.io/) 1.x.
- End to end tests developed in [NodeJs](https://nodejs.org/en/) with [Jest](https://jestjs.io/).
- Performance tests developed with [k6](https://k6.io/).
- [Docker](https://www.docker.com/) images are used to be able to run the web apis locally (dotnet and NodeJs) without installing a thing.

## Features this repo provides

Out of the box, the following features are provided:

- **development**

  Several (dummy) applications are included in the _src_ folder. The folder includes a functional serverless api supported by 4 [Lambdas](https://aws.amazon.com/lambda/) and one containerized application. [Lambdas](https://aws.amazon.com/lambda/) are developed in dotnet-core-3.1, [NodeJs](https://nodejs.org/en/), and [Python](https://www.python.org/) and containerized application in NodeJs. In the same folder, some unit tests are included. In the root folder, you'll find 2 Dockerfiles to create artifact and run tests locally for the dotnet-web-api and NodeJs applications. Both Dockerfiles are meant to help you better develop your api locally.

- **local-load-testing**

  Included in the root folder, there is a folder called _local-testing_. Inside, you'll find a ready-to-run script called _local-testing/scripts/run-load-tests.sh_ that will run a docker-compose file. If you check the script, you'll see that:

  - Creates 2 containers from the applications in _src/dotnet/WebApi_ _src/nodejs/server_.
  - Runs the docker-compose.yml file, which contains:
    - Both dotnet and nodejs applications exposed to particular ports.
    - A time-series database called [influxdb](https://www.influxdata.com/). Which essentially allows to store and retrieve timeseries data.
    - A [graphana](https://grafana.com/) dashboard that pulls data from influxdb.
    - A [k6](https://k6.io/) service that load-tests the apis that your applications expose and stores the stats in influxdb.
  - All together produces a real-time dashboard exposed in the url _http://localhost:3000/d/k6/k6-load-testing-results_ (don't use the url before running the script ... :P) where you can see how your apis respond.

- **continuous-integration**

  The repo provides a _scripts_ and _.github/workflows_ folders out of the box with all the necessary scripts and workflows. This definition includes:

  - ensuring that all commits in a pull request follow [conventional-commits](https://www.conventionalcommits.org/en/v1.0.0/).
  - _unit-tests_ pass.
  - creates and uploads branch artifacts to an s3 bucket.
  - deploys the infrastructure into an aws-account.
  - runs performance tests.
  - runs e2e tests.

- **continuous-delivery/deployment**

  Once a pull request is merged into the **main** branch, the workflow _after-merge-workflow_ is launched. Here, the workflow

  - [semantically versions](https://semver.org/) the repository, and tags your merge commit with the new version.

- **Tests**

  - **Unit testing**

    Inside the _src/dotnet_ folder there is a folder called _Tests_ where some unit tests are developed using [xUnit](https://xunit.net/) and [Moq](https://github.com/moq).

  - **End to end testing**

    The folder _tests/e2e_ holds some e2e tests that represent how your client would call the api once deployed. Allows to run e2e tests against an already deployed api in an aws account.

  - **Performance testing**

    The folder _tests/performance_ holds some _performance_ tests as a .js script that "attacks" your deployed API and computes several stats about your API availability and response time.

- **clean-up infra after pull request**

  A workflow called _clean-up_ will be executed after a pull request is closed (merged or declined). This will ensure no residual infrastructure is left in your AWS account. Good way to avoid extra charges from Amazon :) ...

- **manual-infrastructure-destruction**

  There is a workflow called _destroy_ that will erase your infrastructure in the provided aws account. Use it with caution ;) ...

- **manual-deployment/configuration**

  Check out the _configuration_ branch. Readme file.

- **manual-deployment/configurations**

  There is also a workflow called _deploy-workflow_ that allows you to manually deploy a specific version to an aws-account by introducing the required inputs. Those inputs are:

  - service-version: version of the service to deploy.
  - environment: where to deploy it.
  - service-group: group to be deployed or updated.
  - s3-bucket-name: bucket where the configuration is stored.
  - s3-bucket-key: key of the tfvars file that holds the configuration.

### Up-coming features

- **manual-deployment/configurations**

  There is also a workflow called _deploy-workflow_ that allows you to manually deploy a specific version to an aws-account by introducing the required inputs. Those inputs are:

  - service-version: version of the service to deploy.
  - environment: where to deploy it.
  - service-group: group to be deployed or updated.
  - s3-bucket-name: bucket where the configuration is stored.
  - s3-bucket-key: key of the tfvars file that holds the configuration.

## How to set it up

This repository is (meant to be) provided as a **_self-contained_** and **_plug-and-run_** solution. Nothing external is required to make it work.
To start working on your own solution follow those steps:

- Fork (or clone) the repo to create your own.
- You can build and run both _Dockerfiles.\*_ in the root directory. Something like:
  > docker image build . --file Dockerfile.create-nodejs-server-image --tag name-of-your-choice
  > docker run -p 80:80 name-of-your-choice
  > You can do the same for the _Dockerfile.create-dotnet-webapi-image_ file.
- To start creating pull requests and see some action:

  - check out the required secrets you need on your repository:
    - AWS_ACCESS_KEY: Access key id of the github user.
    - AWS_SECRET_KEY: Secret key of the github user.
    - AWS_ACCOUNT_ID: Aws account id.
    - AWS_REGION: Aws region name.
    - BUCKET_NAME: Name of the s3 bucket where the artifacts, configurations, and [Lambda](https://www.terraform.io/) state files will be stored.
  - Create an [ECR](https://aws.amazon.com/ecr/) repository in your aws account. Once you have the name, copy paste it in an environment variable.

- Create a pull request from a new branch to the main branch.

  - This will trigger the continuous-integration workflow (_github/workflows/ci.yml_).
  - Take into account that all steps in that workflow are conditionally activated based on the folders that have been modified during the pull request.

- Once the pull request is merged to the main branch the continuous-deployment workflow (_github/workflows/cd.yml_) will be activated.

## Who/How to contact

- Eduard Bargués
  - email: eduardbargues@gmail.com
  - linkedin: https://www.linkedin.com/in/eduardbargues/
  - github-profile: https://github.com/EduardBargues
- Open an issue in the same repository: https://github.com/EduardBargues/cicd-template/issues/new

## How to contribute?

- Open a pull request against the main branch (from a forked repo :) ): https://github.com/EduardBargues/cicd-template/pulls
