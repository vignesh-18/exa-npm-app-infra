ifeq ($(OS),Windows_NT) 
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

.DEFAULT_GOAL := explain
explain:
	# Welcome to EXA
	#		________   __                     _______                   __                      
	#		|  ____\ \ / /    /\              |__   __|                 / _|                     
	#		| |__   \ V /    /  \     ______     | | ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___   
	#		|  __|   > <    / /\ \   |______|    | |/ _ \ '__| '__/ _` |  _/ _ \| '__| '_ ` _ \  
	#		| |____ / . \  / ____ \              | |  __/ |  | | | (_| | || (_) | |  | | | | | | 
	#		|______/_/ \_\/_/    \_\             |_|\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_| 
	@echo " Choose a command to run: "                                                                                     
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo " For windows, download the terraform exe using chocolatey or download directly"    
	@echo " INIT is the FIRST command to run when we run first time && PLAN is optional && APPLY is used to deploy the infra"
	@echo " Always deploy infrastructure first using 'infra-apply' command and deploy application secondly using 'app-apply' command"                                                                                 

init: ## initialize the terraform
ifeq ($(detected_OS),Windows)
	# Run WindowsOS commands
	setx AWS_SHARED_CREDENTIALS_FILE "%USERPROFILE%\.aws\credentials"
	cd ./Pipelines && terraform init
	@echo ***terraform Installation Done***
else
	# Run MacOS commands
	export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
	brew install terraform
	cd ./Pipelines && terraform init
	@echo ***terraform Installation Done***
endif

infra-plan: ## to view deployment plan for infrastruture deployment
	@echo ***creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure***
	cd ./Pipelines && terraform plan -target aws_codepipeline.infracodepipeline
	@echo ***Execution plan Created***

app-plan: ## to view deployment plan for application deployment
	@echo ***creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure***
	cd ./Pipelines && terraform plan -target aws_codepipeline.appcodepipeline
	@echo ***Execution plan Created***

infra-apply: ## applies the changes to create infrastruture 
	@echo ***executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure***
	cd ./Pipelines && terraform apply -target aws_codepipeline.infracodepipeline -auto-approve
	@echo ***Infra deploy Pipeline Created***

app-apply: ## applies the changes to deploy application
	@echo ***executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure***
	cd ./Pipelines && terraform apply -target aws_codepipeline.appcodepipeline -auto-approve
	@echo ***Application deploy Pipeline Created***
	