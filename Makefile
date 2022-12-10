
.PHONY: run

container_tag = kiri

build: Dockerfile
	docker build --tag $(container_tag) .

build_no_cache: Dockerfile
	docker build --no-cache --tag $(container_tag) .


stop_all_containers:
	docker kill $(docker ps -q)

remove_all_containers:
	docker rm $(docker ps -a -q)

remove_all_images:
	docker rmi $(docker images -q)


# docker images
# docker ps -a -q


# Don't use this target, this is just my own test case
run:
	./kiri "/home/lheck/Documents/assoc-board"

