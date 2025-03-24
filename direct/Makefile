# Terraform vars

tf_path := ./terraform

tf_backend_config_file := _cfg/backend.json
tf_var_config_file := _cfg/var.json

tf_backend_config_target := $(tf_path)/$(tf_backend_config_file)
tf_var_config_target := $(tf_path)/$(tf_var_config_file)

tf_plan_file := plan.tfplan

tf_init_args := -backend-config=$(tf_backend_config_file)
tf_plan_args := -var-file=$(tf_var_config_file)

# Build vars

build_app ?= false
tf_plan_args := $(tf_plan_args) -var upload_lambda_assets=$(build_app)

aws_account_id := $(shell jq -r '.aws_account_id' $(tf_path)/$(tf_var_config_file) 2>/dev/null)
aws_region := $(shell jq -r '.aws_region' $(tf_path)/$(tf_var_config_file) 2>/dev/null)

commit_sha := $(shell git rev-parse HEAD)

# ECR Repository name when using ECR
image_name := app-docker-lambdas

ecr_repo_url=$(aws_account_id).dkr.ecr.$(aws_region).amazonaws.com/$(image_name)

lambdas := $(shell find lambda/* -type d)

GOOS := linux
GOARCH := arm64

assets_dir := assets

# Targets

.DEFAULT_GOAL := help

.PHONY: apply
apply:
	cd $(tf_path) && \
	terraform apply $(tf_plan_file)
	@cd $(tf_path) && \
	rm -f $(tf_plan_file)


.PHONY: destroy
destroy:
	cd $(tf_path) && \
	terraform destroy $(tf_plan_args) -input=false


.PHONY: plan
plan: init build
	cd $(tf_path) && \
	terraform plan $(tf_plan_args) -out $(tf_plan_file) -input=false


.PHONY: init
init: $(tf_backend_config_target) $(tf_var_config_target)
	cd $(tf_path) && \
	terraform init $(tf_init_args)


.PHONY: build
ifeq ($(build_app),true)
build: clean-assets $(lambdas:%=build/%)
else
build: clean-assets $(lambdas:%=dummy-asset/%)
endif

build/%: LAMBDA = $*
build/%:
	@echo "Building $(LAMBDA)"
	GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build -tags lambda.norpc -o $(assets_dir)/$(LAMBDA)/bootstrap $(LAMBDA)/main.go
	zip -j $(assets_dir)/$(LAMBDA).zip $(assets_dir)/$(LAMBDA)/bootstrap

dummy-asset/%: LAMBDA = $*
dummy-asset/%:
	@echo "Creating dummy ZIP for $(LAMBDA)"
	@mkdir -p $(assets_dir)/$(LAMBDA)
	zip $(assets_dir)/$(LAMBDA).zip .gitignore

.PHONY: clean-assets
clean-assets:
	@rm -rf $(assets_dir)

.PHONY: test
test:
	go test ./...


$(tf_backend_config_target) $(tf_var_config_target):
	@echo '$@ file must exist'
	@false

.PHONY: help
help:
	@echo 'God will help'
