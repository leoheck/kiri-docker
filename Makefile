
container_tag = kiri
container_id = $(shell docker ps -aqf "name=$(container_tag)")

build: Dockerfile
	docker build --tag $(container_tag) .

build_no_cache: Dockerfile
	docker build --no-cache --tag $(container_tag) .


show_containers:
	docker ps -a

stop_all_docker_containers:
	docker ps -q || docker kill $(shell docker ps -q)

remove_all_docker_containers:
	docker rm $(shell docker ps -a -q)

remove_all_docker_images:
	docker rmi $(shell docker images -q | tac)



.PHONY: run_test

# Don't use this target, this is just my own test case
run_test:
	./kiri "/home/lheck/Documents/assoc-board"
