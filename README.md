
# Kiri Docker

Kiri Docker is a convenient and easy way to run [Kiri](https://github.com/leoheck/kiri) with a Docker image.

> Ps.: To run Kiri Docker, Kiri repo is not necessary 

Kiri Docker works by linking inside the docker, user's project, so the resulting files are already accessible in the host system making simple to use the host browser to visualize the generated files.

# Build docker image
```bash
make build
```

# Usage

```bash
export PATH="/home/${USER}/kiri-docker"
kiri PROJECT_PATH [EXTRA_KIRI_PARAMETERS]
```

# Example

This example launches kiri (docker), passing the path of the project and kiri `-r` flag to clean old files.

```
./kiri "/home/lheck/Documents/assoc-board" -r
```