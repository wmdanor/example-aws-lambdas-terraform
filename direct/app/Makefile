# Export vars
GOOS := linux## GOOS environment variable used for build
GOARCH := arm64## GOARCH environment variable used for build

FUNCTION_NAME_PREFIX := ## String that will be prefixed in front of folder names for deployment

EXCLUDE := ## Comma separatedambda folders to exclude from push

# Internal vars
lambdas_dir := lambda
assets_dir := assets

comma := ,
exclude_lambdas := $(subst $(comma), ,$(EXCLUDE))

# In the current implementation function name must
# match with folder name of the function package
lambdas := $(shell ls $(lambdas_dir))
push_lambdas := $(filter-out $(exclude_lambdas),$(lambdas))

help_sh := ./../../help.sh

# Targets

.DEFAULT_GOAL := help

.PHONY: deploy
deploy: | clean build push## Build and upload lambda code


.PHONY: push
push: $(push_lambdas:%=push/%)## Upload lambda code
push/%: LAMBDA = $*
push/%:
	@echo "Pushing '$(LAMBDA)' lambda code"
	aws lambda update-function-code \
		--function-name '$(FUNCTION_NAME_PREFIX)$(LAMBDA)' \
		--zip-file fileb://$(assets_dir)/$(LAMBDA).zip --no-cli-pager


.PHONY: build
build: $(lambdas:%=build/%)## Build lambda code
build/%: LAMBDA = $*
build/%:
	@echo "Building '$(LAMBDA)' lambda code"
	GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 go build -tags lambda.norpc -o $(assets_dir)/$(LAMBDA)/bootstrap $(lambdas_dir)/$(LAMBDA)/main.go
	zip -j $(assets_dir)/$(LAMBDA).zip $(assets_dir)/$(LAMBDA)/bootstrap


.PHONY: clean
clean:## Delete previously built lambda assets
	@rm -rf $(assets_dir)


.PHONY: test
test:## Run tests
	go test ./...


.PHONY: help
help:
	@$(help_sh) "$(MAKEFILE_LIST)"
