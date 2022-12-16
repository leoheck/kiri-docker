
# Kiri Docker

Kiri Docker is a convenient and easy way to run [Kiri](https://github.com/leoheck/kiri) with a Docker image.

> Kiri repo is not necessary to run Kiri Docker

Kiri Docker works by linking the user project inside the docker. The resulting files are already accessible in the host system making simple to use the host browser to visualize the generated files.

The existing kiri image is hosted in Docker Hub here https://hub.docker.com/r/leoheck/kiri/tags

# Getting the existing docker image

There is a docker image prepared and ready for Kiri. It can be accessed through this repo with:

```bash
gh repo clone leoheck/kiri-docker
make docker_pull
```

Alternatively, this is the latest image file
```bash
docker pull leoheck/kiri:latest
```

# Building your own docker image

Alternatively, you can also build the docker image yourself

```bash
gh repo clone leoheck/kiri-docker
cd kiri-docker
make build
```

# Environment

Download or build the docker image and then set your PATH to this repo with:

```bash
export PATH="$(pwd)/kiri-docker/"
```

# Using Kiri (docker)

To run kiri on your Kicad project repository:

```bash
kiri [OPTIONS] [REPO_PATH] [-k|--kiri [ARGS]
```

For extended arguments list, please use the flag `-h`.

# Example

This example launches kiri (docker), passing the path of the project path and a parameter `-r` of kiri to remove old files before of running it.

```bash
kiri "/home/lheck/Documents/assoc-board" -k -r
```

This example starts the container passing the project folder to mount there but do nothing (do not run kiri) so you can debug something manually.

```bash
kiri "/home/lheck/Documents/assoc-board" -d
```

Launch kiri on a project in a nested folder

```bash
kiri "/home/lheck/Documents/assoc-board" -k "nested_project/board.kicad_pro"
```

This, just launch the container without binding any local folder

```bash
kiri
```
