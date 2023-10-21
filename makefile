# CONTAINER_CLI=docker
# CONTAINER_CLI=nerdctl
CONTAINER_CLI=colima nerdctl --
CONTAINER_TAG=quay.io/clanktron/nas
COMMIT_HASH=$(shell git rev-parse HEAD)
CONTAINERFILE=Containerfile
VERSION=0.1.1

.PHONY: container
container:
	$(CONTAINER_CLI) build -t $(CONTAINER_TAG):$(COMMIT_HASH) --build-arg VERSION=$(COMMIT_HASH) -f $(CONTAINERFILE) .

.PHONY: container-release
container-release:
	$(CONTAINER_CLI) build -t $(CONTAINER_TAG):$(VERSION) --build-arg VERSION=$(VERSION) -f $(CONTAINERFILE) .

.PHONY: container-push
container-push: container
	$(CONTAINER_CLI) push $(CONTAINER_TAG):$(COMMIT_HASH)

.PHONY: clean
clean:
	rm -r test/*
