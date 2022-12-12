
docker_username = leoheck
docker_repo = kiri
docker_tagname = 1.0

docker_build: Dockerfile
	docker build --tag $(docker_username)/$(docker_repo) .

docker_build_no_cache: Dockerfile
	docker build --no-cache --tag $(docker_username)/$(docker_repo) .

docker_login:
	docker login

docker_push: docker_build
	docker push $(docker_username)/$(docker_repo)


# get the latest kiri image from docker hub
docker_pull:
	docker pull $(docker_username)/$(docker_repo)


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
