PROJECT=dev-server
AUTHOR=squziduos
PORT=8001

VERSION=$(shell git rev-parse --short HEAD)

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build --no-cache -t $(PROJECT):debug .

run: ## Run container on port configured in `config.env`
	docker run -i -t --rm --env-file=debug.env -p=$(PORT):8000 -v "/var/run/docker.sock:/var/run/docker.sock" --name="$(PROJECT)-debug" $(PROJECT):debug

stop: ## Stop and remove a running container
	docker stop $(PROJECT)-debug; docker rm $(PROJECT)-debug

# Docker publish
publish: repo-login publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## Publish the `latest` taged container to ECR
	@echo 'publish $(AUTHOR)/$(PROJECT):latest to Docker Hub'
	docker push $(AUTHOR)/$(PROJECT):latest

publish-version: tag-version ## Publish the `{version}` taged container to ECR
	@echo 'publish $(AUTHOR)/$(PROJECT):$(VERSION) to Docker Hub'
	docker push $(AUTHOR)/$(PROJECT):${VERSION}

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(PROJECT):debug $(AUTHOR)/$(PROJECT):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(PROJECT):debug $(AUTHOR)/$(PROJECT):$(VERSION)

repo-login:
	docker login
