# exa-npm-app-infra

EXA Devops Assessment: Infrastruture

This repo builds the entire Infrastruture stack.
  - Code Pipelines (Application Deployment && Infrastruture Deployment)
  - IAM roles and policies
  - VPC with security groups
  - Elastic Container Registry
  - Elastic Container Service
  - Application Load balancer

Highlights:
  - Highly secured and resilient architecture
  - Infra code and application code are isolated by having two different repos.
  - Terraform uses S3 + Dynamo DB as remote backend

  ## Run with Makefile

Setup AWS SSO access:
- You need to copy the temporary SSO credentials to a credentials file in the .aws folder and profile name should be "general_account_personal"

In project root directory run the following commands

```shell
make
```

Which will provide the following helpful commands:

```shell
# Welcome to EXA
#               ________   __                     _______                   __
#               |  ____\ \ / /    /\              |__   __|                 / _|
#               | |__   \ V /    /  \     ______     | | ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___
#               |  __|   > <    / /\ \   |______|    | |/ _ \ '__| '__/ _` |  _/ _ \| '__| '_ ` _ \
#               | |____ / . \  / ____ \              | |  __/ |  | | | (_| | || (_) | |  | | | | | |
#               |______/_/ \_\/_/    \_\             |_|\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_|
 Choose a command to run:
apply                          applies the changes
init                           initialize the terraform
plan                           to view deployment plan
For windows, download the terraform exe using chocolatey or download directly.
INIT is the FIRST command to run when we run first time && PLAN is optional && APPLY is used to deploy the infra
```
## Application Repo
https://github.com/vignesh-18/exa-devops-assessment

## Infrastruture Repo
https://github.com/vignesh-18/exa-npm-app-infra

## Architecture Documentation
https://github.com/vignesh-18/exa-npm-app-infra - Refer Architecture directory

## Future Enhancements
  - Refactor current code into modules
  - VPC endpoint can be used to instead of NAT
  - NACL can be used as an additional firewall
