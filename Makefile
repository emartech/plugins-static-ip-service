SHELL=/bin/bash
.PHONY: help build up down test

help: ## Show this help
	@echo "Targets:"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\(.*\):.*##[ \t]*/    \1 ## /' | sort | column -t -s '##'

build: ## Build Nginx container
	DOCKER_BUILDKIT=1 docker build -t plugins-static-ip-service .

up: ## Start Nginx container
	docker-compose up

down: ## Stops Nginx container
	docker-compose down

rebuild: down build up

sample-call: ## Make sample HTTPbin request
	curl -X POST -d '{"foo": "bar", "bar": 123}' -H "X-Proxy-Authorization: Bearer foobar" -H "X-Proxy-Base-Url:https://httpbin.org" http://qqq:www@localhost:8080/anything/fizz/buzz?aaa=bbb

up-from-image:
	docker run -d --name plugins-static-ip-service -p '8080:8090' -e 'PROXY_USER=qqq' -e 'PROXY_PASSWORD=www' -e 'PROXY_USER_NEW=aaa' -e 'PROXY_PASSWORD_NEW=sss' emarsys/plugins-static-ip-service:$(shell git rev-parse HEAD)
