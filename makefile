CONTAINER_CLI=docker
# CONTAINER_CLI=nerdctl
CONTAINER_TAG=clanktron/nas
VERSION=0.1.0

container:
	$(CONTAINER_CLI) build -t $(CONTAINER_TAG):$(VERSION) -f Containerfile .
