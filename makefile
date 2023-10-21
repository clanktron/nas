# CONTAINER_CLI=docker
# CONTAINER_CLI=nerdctl
CONTAINER_CLI=colima nerdctl --
CONTAINER_TAG=clanktron/nas
COMMIT_HASH=$(shell git rev-parse HEAD)
VERSION=0.1.1

container:
	$(CONTAINER_CLI) build -t $(CONTAINER_TAG):$(COMMIT_HASH) --build-arg VERSION=$(COMMIT_HASH) -f Containerfile .

container-release:
	$(CONTAINER_CLI) build -t $(CONTAINER_TAG):$(VERSION) --build-arg VERSION=$(VERSION) -f Containerfile .
