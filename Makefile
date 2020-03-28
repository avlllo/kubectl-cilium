SHELL := /bin/bash

ROOT := $(shell git rev-parse --show-toplevel)

VERSION := $(shell git describe --always --dirty=-dev)

.PHONY: build
build:
	@CGO_ENABLED=0 go build -ldflags="-X github.com/bmcstdio/kubectl-cilium/internal/version.Version=$(VERSION)" \
		-v -o "$(ROOT)/bin/kubectl-cilium" -tags netgo "$(ROOT)/cmd/kubectl-cilium/"

.PHONY: ci
ci: lint build

$(ROOT)/bin/golangci-lint:
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.24.0

.PHONY: lint
lint: $(ROOT)/bin/golangci-lint
	@$(ROOT)/bin/golangci-lint run --enable-all --disable gochecknoglobals,gochecknoinits,gomnd,lll,wsl --timeout 5m
