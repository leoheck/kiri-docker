
dockerfile = Dockerfile

docker_username = leoheck
docker_repo = kiri
docker_tagname = latest

docker_build: $(dockerfile)
	time docker build \
		-f $(dockerfile) \
		--tag $(docker_username)/$(docker_repo):$(docker_tagname) .
	docker images

docker_build_no_cache: $(dockerfile)
	time docker build \
		-f $(dockerfile) \
		--no-cache \
		--tag $(docker_username)/$(docker_repo):$(docker_tagname) .
	docker images


docker_login:
	docker login

docker_push: docker_build
	docker push $(docker_username)/$(docker_repo):$(docker_tagname)



# get the latest kiri image from docker hub
docker_pull:
	docker pull $(docker_username)/$(docker_repo):$(docker_tagname)


show_containers:
	docker ps -a

stop_all_docker_containers:
	docker ps -q || docker kill $(shell docker ps -q)

remove_all_docker_containers:
	docker ps -a -q || docker rm $(shell docker ps -a -q)

remove_all_docker_images:
	docker images -q || docker rmi $(shell docker images -q | tac)

system_prune:
	make stop_all_docker_containers
	make remove_all_docker_containers
	make remove_all_docker_images
	yes | docker system prune


.PHONY: run_test

testcase_path = "/home/lheck/Documents/assoc-board"

# Don't use this target, this is just my own test case
run_test:
	./kiri $(testcase_path)
