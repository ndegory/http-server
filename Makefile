.PHONY: all image up down clean

IMAGE := ndegory/httpd

all: image

httpd.linux: main.go
	GOOS=linux go build -ldflags="-s -w" -o httpd.linux .

image: httpd.linux
	docker build -t $(IMAGE):scratch .
	docker tag $(IMAGE):scratch $(IMAGE)

alpine-image:
	docker build -t $(IMAGE):alpine -f Dockerfile.alpine .
	docker tag $(IMAGE):alpine $(IMAGE)

up:
	@docker run -d --rm --name httpd -p 80:80 $(IMAGE)

down:
	@docker kill httpd 2>/dev/null || exit 0

clean: down
	@rm -f httpd.linux
	@docker image list -q $(IMAGE) | xargs docker image rm -f
