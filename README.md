# CICD-TEMPLATE

This repo is meant to provide an initial template for teams so they can fork it and start working on it. Plug and run solution that holds a web api supported by a lambda and developed in aspnetcore 3.1. Useful for teams that look for a functional solution that requires minimum configuration.

- WebApi developed in C# and AspNetCore 3.1 (supported by a lambda).
- Infrastructure as Code using Terraform 1.x.
- End to end tests developed in NodeJs with Jest.
- Docker images are used to be able to run the web api locally without installing anything.

## How to deploy/configure

1. In your s3-bucket, upload a _.tfvars(.json)_ file with the compatible variables of the version you want to deploy. The file key must be "configurations/_ENVIRONMENT_/_SERVICE_NAME_/_GROUP_/_SERVICE_NAME_-_ENVIRONMENT_-_GROUP_.tfvars.json".
2. Create a pull request against the branch _configuration_. In the pull request you must create a file _configuration/conf.json_ setting up the required variables. Check the file _configuration/conf.json.example_ for guidance.

- During the pull request, a terraform plan will be done for you. You can check the plan to see potential issues before merge.
- Once merged, github-actions will apply that plan.
