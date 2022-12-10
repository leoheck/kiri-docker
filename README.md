
# Kiri Docker

Kiri Docker is a convenient and easy way to run [Kiri](https://github.com/leoheck/kiri) with a Docker image.

> Kiri repo is not necessary to run Kiri Docker

Kiri Docker works by linking the user project inside the docker. The resulting files are already accessible in the host system making simple to use the host browser to visualize the generated files.

# Building docker image
```bash
gh repo clone leoheck/kiri-docker
cd kiri-docker
make build
```

# Usage

```bash
export PATH="$(pwd)/kiri-docker"
kiri PROJECT_PATH [KIRI_PARAMETERS]
```

# Example

This example launches kiri (docker), passing the path of the project and kiri `-r` flag to clean old files.

```bash
kiri "/home/lheck/Documents/assoc-board" -r
```

