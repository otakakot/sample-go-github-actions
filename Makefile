SHELL := /bin/bash
include .env
export
export APP_NAME := $(basename $(notdir $(shell pwd)))

.PHONY: help
help: ## display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: tool
tool: ## install tool
	@aqua install
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

.PHONY: build
build: ## go build
	@go build -v ./... && go clean

.PHONY: fmt
fmt: ## go format
	@go fmt ./...

.PHONY: lint
lint: ## go lint ref. https://golangci-lint.run/
	@golangci-lint run ./... --fix

.PHONY: module
module: ## go modules and update
	@go get -u -t ./...
	@go mod tidy

.PHONY: gen
gen: ## Generate code.
	@go generate ./...
	@go mod tidy

.PHONY: up
up: ## docker compose up with air hot reload
	@docker compose --project-name ${APP_NAME} --file ./.docker/compose.yaml up --detach

.PHONY: down
down: ## docker compose down
	@docker compose --project-name ${APP_NAME} down --volumes

.PHONY: test
test: ## unit test
	@$(call _test,${c})

define _test
if [ -z "$1" ]; then \
	go test ./internal/... ; \
else \
	go test ./internal/... -count=1 ; \
fi
endef

.PHONY: integration
integration: ## run integration test. If you want to invalidate the cache, please specify an argument like `make integration c=c`.
	@$(call _integration,${c})

define _integration
if [ -z "$1" ]; then \
	go test ./test/integration/... ; \
else \
	go test ./test/integration/... -count=1 ; \
fi
endef

.PHONY: e2e
e2e: ## run e2e test. If you want to invalidate the cache, please specify an argument like `make e2e c=c`.
	@$(call _e2e,${c})

define _e2e
if [ -z "$1" ]; then \
	go test ./test/e2e/... ; \
else \
	go test ./test/e2e/... -count=1 ; \
fi
endef
