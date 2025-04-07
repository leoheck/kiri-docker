
# Kiri Docker

Kiri Docker is a convenient and easy way to run [Kiri](https://github.com/leoheck/kiri) pre-installed in a Ubuntu container.

> Kiri repo is not necessary to run Kiri Docker

Kiri Docker works by mounting the user's project from the host machine inside the container. This way, the output files are easily accessible from the host system making it simple to visualize using the host's browser.

The existing kiri-docker image is hosted in Docker Hub here https://hub.docker.com/r/leoheck/kiri/tags

# Getting the existing docker image

The docker container can be donwloaded through this repo with:

```bash
gh repo clone leoheck/kiri-docker
make docker_pull
```

Alternatively, you can pull the latest image file with:
```bash
docker pull leoheck/kiri:latest
```

# Building your own docker image

It is also possible to build the docker image yourself, if needed:

```bash
gh repo clone leoheck/kiri-docker
cd kiri-docker
make docker_build
```

# Environment

Download or build the docker image and then set your PATH to this repo with:

```bash
export PATH=$PATH:{PATH-TO-THIS-REPO}
```

# Using Kiri Docker

To run kiri on the given Kicad project repository:

```bash
kiri-docker [OPTIONS] [REPO_PATH] [-k|--kiri [ARGS]
```

For extended arguments list, please use the flag `-h`.

# Examples

Just launch the container for manual exploration

```bash
kiri-docker
```

This example launches kiri-docker, passing the path of the project path and a parameter `-r` of kiri to remove old files.

```bash
kiri-docker "/home/lheck/Documents/assoc-board" -k -r
```

This, starts the container with the project folder and do nothing, so you can debug something manually.

```bash
kiri-docker "/home/lheck/Documents/assoc-board" -d
```

Launch kiri with a repo that has a nested kicad project (kicad project is not in the root path)

```bash
kiri-docker "/home/lheck/Documents/assoc-board" -k "nested_project/board.kicad_pro"
```

Starts docker binding project's repo, do not run kiri, and run pcbdraw command:
This example uses the image generated with `Dockerfile_kicad-auto`.

```bash
kiri-docker "/home/lheck/Documents/assoc-board" -i leoheck/kiri:test -d -c "pcbdraw board.kicad_pcb board.svg"
```
