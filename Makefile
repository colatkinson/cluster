all:
.PHONY: all

.tmp:
	mkdir -p $@

.tmp/minikube: | .tmp
	minikube start --vm-driver=docker
	touch $@

start-minikube: | .tmp/minikube
.PHONY: start-minikube

.tmp/local-registry: | .tmp/minikube
	minikube addons enable registry
	docker stop registry-fwd || true
	while ! curl "$(shell minikube ip):5000" 2>/dev/null; do sleep 0.1; done
	docker run --name registry-fwd -d --rm -it --network=host alpine ash -c \
		"apk add socat && \
			socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(shell minikube ip):5000"
	while ! curl "localhost:5000" 2>/dev/null; do sleep 0.1; done
	touch $@

local-registry: | .tmp/local-registry
.PHONY: local-registry

.tmp/minikube-ingress: | .tmp/minikube
	minikube addons enable ingress

start-dev: | .tmp/minikube-ingress .tmp/local-registry
	bazel build //:all
	bazel run //:all.apply --workspace_status_command="./status/dev.sh"
.PHONY: start-dev

reapply-dev:
	bazel run //:all.apply --workspace_status_command="./status/dev.sh"
.PHONY: reapply-dev

stop-dev:
	bazel run //:all.delete --workspace_status_command="./status/dev.sh"
	docker stop registry-fwd || true
	minikube delete
	rm -rf .tmp
.PHONY: stop-dev
