
.PHONY: build
build:
	docker build \
	--no-cache \
	--build-arg=BASE_IMAGE=$(BASE_IMAGE) \
	--build-arg=BASE_IMAGE_VERSION=$(BASE_IMAGE_VERSION) \
	-t $(IMAGE_NAME)-candidate .

.PHONY: test
test:
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run

.PHONY: prepare-release
prepare-release:
	docker tag $(IMAGE_NAME)-candidate taconsol/$(IMAGE_NAME):$(TAG_VERSION)
	docker tag $(IMAGE_NAME)-candidate taconsol/$(IMAGE_NAME):latest

.PHONY: prepare-latest
prepare-latest:
	docker tag $(IMAGE_NAME)-candidate taconsol/$(IMAGE_NAME):latest

.PHONY: release
release:
	docker push taconsol/$(IMAGE_NAME):$(TAG_VERSION)
	docker push taconsol/$(IMAGE_NAME):latest

.PHONY: release-latest
release-latest:
	docker push taconsol/$(IMAGE_NAME):latest
