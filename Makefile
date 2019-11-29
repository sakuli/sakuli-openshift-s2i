IMAGE_NAME = sakuli-s2i
SAKULI_VERSION = 2.2.0

.PHONY: build
build:
	docker build --build-arg=BASE_IMAGE_VERSION=$(SAKULI_VERSION) -t $(IMAGE_NAME)-candidate .

.PHONY: test
test:
	test/run

.PHONY: prepare-release
prepare-release:
	docker tag $(IMAGE_NAME)-candidate taconsol/$(IMAGE_NAME):$(SAKULI_VERSION)

.PHONY: release
release:
	docker push taconsol/$(IMAGE_NAME):$(SAKULI_VERSION)
