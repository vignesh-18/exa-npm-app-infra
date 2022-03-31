ifeq ($(OS),Windows_NT) 
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

.DEFAULT_GOAL := explain
explain:
#		________   __                     _______                   __                      
#		|  ____\ \ / /    /\              |__   __|                 / _|                     
#		| |__   \ V /    /  \     ______     | | ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___   
#		|  __|   > <    / /\ \   |______|    | |/ _ \ '__| '__/ _` |  _/ _ \| '__| '_ ` _ \  
#		| |____ / . \  / ____ \              | |  __/ |  | | | (_| | || (_) | |  | | | | | | 
#		|______/_/ \_\/_/    \_\             |_|\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_| 
### Welcome
### Targets
@echo " Choose a command to run: "                                                                                     
@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'                                                                                      

init: ## init
ifeq ($(detected_OS),Windows)
	# Run WindowsOS commands
	setx AWS_SHARED_CREDENTIALS_FILE "%USERPROFILE%\.aws\credentials"
	pip install requests
	pwd
	cd ./Pipelines && terraform init
	@echo ***terraform Installation Done***
else
	# Run MacOS commands
	export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
	pip install requests
	brew install terraform
	cd ./Pipelines && terraform init
	@echo ***terraform Installation Done***
endif

plan: ## to view deployment plan
	@echo ***creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure***
	cd ./Pipelines && terraform plan

apply: ## applies the changes
	@echo ***executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure***
	cd ./Pipelines && terraform apply
	@echo ***Deployement Completed***
