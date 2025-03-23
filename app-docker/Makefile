# Terraform vars

tf_path := ./terraform

tf_backend_config_file := _cfg/backend.json
tf_var_config_file := _cfg/var.json

tf_backend_config_target := $(tf_path)/$(tf_backend_config_file)
tf_var_config_target := $(tf_path)/$(tf_var_config_file)

tf_plan_file := plan.tfplan

tf_init_arg := -backend-config=$(tf_backend_config_file)
tf_plan_arg := -var-file=$(tf_var_config_file)

# account_id := $(shell aws sts get-caller-identity | jq -r '.Account')

# Build vars

build_app ?= false

aws_account_id := $(shell jq -r '.aws_account_id' $(tf_path)/$(tf_var_config_file) 2>/dev/null)
aws_region := $(shell jq -r '.aws_region' $(tf_path)/$(tf_var_config_file) 2>/dev/null)

commit_sha := $(shell git rev-parse HEAD)

# ECR Repository name when using ECR
image_name := app-docker-lambdas

ecr_repo_url=$(aws_account_id).dkr.ecr.$(aws_region).amazonaws.com/$(image_name)

# lambdas := $(shell find lambda/* -type d)
lambdas := $(shell ls lambda)

# Targets

.DEFAULT_GOAL := help

# TODO: should i make image push part of apply? and then ref img by tag instead of image_uri? cuz when planning new img won't exist then
.PHONY: apply
apply:
	cd $(tf_path) && \
	terraform apply $(tf_plan_file)
	@cd $(tf_path) && \
	rm -f $(tf_plan_file)


.PHONY: destroy
destroy:
	cd $(tf_path) && \
	terraform destroy


.PHONY: plan
plan: init build
	cd $(tf_path) && \
	terraform plan $(tf_plan_arg) -out $(tf_plan_file) -input=false
	@echo 'To perform exactly these actions, run the following command to apply:'
	@echo '    make apply'


.PHONY: init
init: $(tf_backend_config_target) $(tf_var_config_target)
	cd $(tf_path) && \
	terraform init $(tf_init_arg) -reconfigure


.PHONY: build
ifeq ($(build_app),true)
build: | image-build image-push
else
build:
endif

.PHONY: image-build
image-build: $(lambdas:%=image-build/%)
image-build/%: LAMBDA = $*
image-build/%: image_tag_scope = $(LAMBDA)
image-build/%: image_tag_version = $(image_tag_scope)-$(commit_sha)
image-build/%: image_tag_latest = $(image_tag_scope)-latest
image-build/%:
	@echo "Building $(LAMBDA)"
	docker build -t $(image_name):$(image_tag_version) . --build-arg lambda=$(LAMBDA)
	docker tag $(image_name):$(image_tag_version) $(image_name):$(image_tag_latest)
	docker tag $(image_name):$(image_tag_version) $(ecr_repo_url):$(image_tag_version)
	docker tag $(image_name):$(image_tag_version) $(ecr_repo_url):$(image_tag_latest)

.PHONY: image-push
image-push: $(lambdas:%=image-push/%)
image-push/%: LAMBDA = $*
image-push/%: image_tag_scope = $(LAMBDA)
image-push/%: image_tag_version = $(image_tag_scope)-$(commit_sha)
image-push/%: image_tag_latest = $(image_tag_scope)-latest
image-push/%:
	@echo "Pushing $(LAMBDA)"
	aws ecr get-login-password --region eu-west-1 | \
	docker login --username AWS --password-stdin $(ecr_repo_url) && \
	docker push $(ecr_repo_url):$(image_tag_latest)

.PHONY: test
test:
	go test ./...


$(tf_backend_config_target) $(tf_var_config_target):
	@echo '$@ file must exist'
	@false

.PHONY: help
help:
	@echo 'God will help'
