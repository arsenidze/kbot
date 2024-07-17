APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=gcr.io
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

TARGETOS ?= linux
TARGETARCH ?= $(shell dpkg --print-architecture || amd64)

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/arsenidze/kbot/cmd.appVersion=${VERSION}

linux: 
	TARGETOS=linux TARGETARCH=${TARGETARCH} make build

darwin: 
	TARGETOS=darwin TARGETARCH=${TARGETARCH} make build

windows: 
	TARGETOS=windows TARGETARCH=${TARGETARCH} make build

arm: 
	TARGETOS=${TARGETOS} TARGETARCH=arm make build

image:
	docker build --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
