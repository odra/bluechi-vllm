SHELL := /bin/bash
TOOLS_DIR := ./tools
AIB_URL := https://gitlab.com/CentOS/automotive/src/automotive-image-builder/-/raw/main/auto-image-builder.sh?ref_type=heads
AIB_IMG_DIR := ./images/aib
OUTPUTS_DIR := ./outputs

.PHONY: aib/prepare
aib/prepare:
	mkdir -p ${TOOLS_DIR} ${OUTPUTS_DIR}
	curl -L -o ${TOOLS_DIR}/auto-image-builder.sh '${AIB_URL}'
	chmod +x ${TOOLS_DIR}/auto-image-builder.sh

.PHONY: aib/image/build
aib/image/build:
	sudo bash ${TOOLS_DIR}/auto-image-builder.sh build \
	--distro autosd9 \
	--mode image \
	--target qemu \
	--export qcow2 \
	--define-file ${AIB_IMG_DIR}/vars.yml \
	${AIB_IMG_DIR}/image.aib.yml \
	${OUTPUTS_DIR}/disk.qcow2

.PHONY: aib/image/post
aib/image/post:
	sudo chown $(shell logname) ${OUTPUTS_DIR}/disk.qcow2

.PHONY: aib/image/run
aib/image/run:
	automotive-image-runner --nographic ${OUTPUTS_DIR}/disk.qcow2

.PHONY: aib/image
aib/image: aib/image/build aib/image/post
