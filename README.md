
# Kiri Docker

Kiri Docker is a convenient and easy way to run [Kiri](https://github.com/leoheck/kiri) with a Docker image.

> Kiri repo is not necessary to run Kiri Docker

Kiri Docker works by linking the user project inside the docker. The resulting files are already accessible in the host system making simple to use the host browser to visualize the generated files.

# Building the docker image
```bash
gh repo clone leoheck/kiri-docker
cd kiri-docker
make build
```

# Environment

```bash
export PATH="$(pwd)/kiri-docker/"
```

# Usage

To run kiri on your repo:

```bash
kiri PROJECT_PATH [KIRI_PARAMETERS]
```

To just go inside the container doing nothing, call kiri without parameters.

```bash
kiri
```

# Example

This example launches kiri (docker), passing the path of the project and kiri `-r` flag to clean old files.

```bash
kiri "/home/lheck/Documents/assoc-board" -r
```
