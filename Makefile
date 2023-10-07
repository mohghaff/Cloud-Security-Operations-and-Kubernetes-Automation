.PHONY: run_website stop_website install_kind create_kind_cluster create_docker_registry \
connect_registry_to_kind_network connect_registry_to_kind create_kind_cluster_with_registry \
delete_kind_cluster delete_docker_registry

run_website:
	docker build -t explorecalifornia.com . && \
		docker run --rm --name explorecalifornia.com -p 5000:80 -d explorecalifornia.com 

stop_website:
	docker stop explorecalifornia.com

install_kind:
	Invoke-WebRequest -Uri 'https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-windows-amd64' -OutFile './kind.exe'

create_kind_cluster: install_kind create_docker_registry
	kind create cluster --name explorecalifornia.com --config ./kind_config.yaml || true && \
	kubectl get nodes

create_docker_registry:
	@if docker ps | grep -q 'local-registry'; then \
		echo "local-registry already created"; \
	else \
		docker run --name local-registry -d --restart=always -p 5001:5001 registry:2; \
	fi
connect_registry_to_kind_network:
	docker network connect kind local-registry || true

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f ./kind_configmap.yaml

# create_kind_cluster_with_registry:create_kind_cluster connect_registry_to_kind


delete_kind_cluster:
	kind delete cluster --name explorecalifornia.com

delete_docker_registry:
	docker stop local-registry \
	docker rm local-registry
