CLI=docker
# CLI=nerdctl
# CLI=colima nerdctl --
DISTRO=ubuntu
# DISTRO=tumbleweed
COMMIT_HASH=$(shell git rev-parse HEAD)
CONTAINER_TAG=quay.io/clanktron/nas-$(DISTRO)
IMAGE=$(CONTAINER_TAG):$(COMMIT_HASH)
CONTAINERFILE=Containerfile.$(DISTRO)
VERSION=0.1.1

.PHONY: container
container:
	$(CLI) build -t $(IMAGE) --build-arg VERSION=$(COMMIT_HASH) -f $(CONTAINERFILE) .

.PHONY: push
push:
	$(CLI) push $(IMAGE)

.PHONY: iso
iso:
	$(CLI) run -v $(PWD)/build:/tmp/auroraboot \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--rm -ti quay.io/kairos/auroraboot \
                --set container_image=$(IMAGE) \
                --set "disable_http_server=true" \
                --set "disable_netboot=true" \
                --set "state_dir=/tmp/auroraboot" --debug

.PHONY: iso-local
iso-local:
	$(CLI) run -v $(PWD)/build-local:/tmp/auroraboot \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--rm -ti quay.io/kairos/auroraboot \
		--set container_image=docker://$(IMAGE) \
                --set "disable_http_server=true" \
                --set "disable_netboot=true" \
                --set "state_dir=/tmp/auroraboot" --debug

.PHONY: clean
clean:
	sudo rm -rf test/* build/*
