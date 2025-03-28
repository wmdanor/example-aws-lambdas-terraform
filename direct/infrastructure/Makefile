# Export vars

ARGS := ## Args to be additionally passed to Terraform CLI

# Internal vars

tf_backend_config_file := backend.json

tf_plan_file := plan.tfplan

tf_init_args := -backend-config=$(tf_backend_config_file)

dummy_asset_file := dummy.zip

help_sh := ./../../help.sh

# Targets

.DEFAULT_GOAL := help

.PHONY: deploy
deploy: | plan apply ## Plan and apply without confirmation


.PHONY: apply
apply:## Apply previously created plan
	terraform apply $(tf_plan_file) $(ARGS)
	@rm -f $(tf_plan_file)


.PHONY: destroy
destroy:## Destroy created infrastructure
	terraform destroy -input=false $(ARGS)


.PHONY: plan
plan: init## Plan infrastructure changes and save to a file
	terraform plan -out $(tf_plan_file) -input=false $(ARGS)


.PHONY: init
init: $(tf_backend_config_file) $(dummy_asset_file)
	terraform init $(tf_init_args)


.PHONY: clean
clean:## Delete dummy asset and .terraform folder
	@rm -f $(dummy_asset_file)
	@rm -rf .terraform


$(dummy_asset_file):
	zip $(dummy_asset_file) .gitignore


$(tf_backend_config_file):
	@aws ssm get-parameter --name /terraform/backend/config --with-decryption | \
		jq -r '.Parameter.Value' | \
		jq > $(tf_backend_config_file)


.PHONY: help
help:
	@$(help_sh) "$(MAKEFILE_LIST)"
