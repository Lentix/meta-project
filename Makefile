# app name should be overridden.
# ex) production-stage: make build APP_NAME=<APP_NAME>
# ex) development-stage: make build-dev APP_NAME=<APP_NAME>

REPO_NAME = meta-project
REPO_NAME := $(REPO_NAME) 

APP_NAME = discord
APP_NAME := $(APP_NAME), $(APP_NAME)

.PHONY: build
# Build the container image - Dvelopment
build-dev:
	docker build -t ${APP_NAME}\
		--target development-build-stage\
		-f Dockerfile .

# Build the container image - Production
build:
	docker build -t ${APP_NAME}\
		--target production-build-stage\
		-f Dockerfile .

# Clean the container image
clean:
	docker rmi -f ${APP_NAME}


all: build

help:
	echo help

babel:
	babel lib/ -d src/

test: babel
	mocha -R spec

eslint:
	DEBUG="eslint:cli-engine" eslint .

watch:
	watchd lib/**.js test/**.js package.json -c 'bake babel'

release: version push publish

version:
	standard-version -m '%s'

push:
	git push origin master --tags

publish:
	npm publish
