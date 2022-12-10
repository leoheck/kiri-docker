
# We are going to use the latest version of ubuntu, of course
FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG TERM='dumb'

RUN apt-get update

RUN apt-get install -y apt-utils
RUN apt-get install -y sudo
RUN apt-get install -y iproute2
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y bc
RUN apt-get install -y coreutils
RUN apt-get install -y software-properties-common
RUN apt-get install -y x11-apps
RUN apt-get install -y x11-xkb-utils
RUN apt-get install -y xvfb
RUN apt-get install -y libc-bin

# install kiri dependencies
RUN bash -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/leoheck/kiri/main/install_dependencies.sh)"

# create kiri user
RUN useradd -rm -d "/home/kiri" -s "/bin/bash" -g root -G sudo -u 1000 kiri -p kiri

# set password of kiri user
RUN echo "kiri:kiri" | chpasswd

# run sudo without password
RUN echo "kiri ALL=(ALL) NOPASSWD:ALL" | tee sudo -a /etc/sudoers

USER kiri
WORKDIR "/home/kiri"

# ask kiri password for sudo
RUN echo "kiri" | tee sudo -i

# kiri install
RUN bash -c "INSTALL_KIRI_REMOTELLY=1; $(/usr/bin/curl -fsSL https://raw.githubusercontent.com/leoheck/kiri/main/install_kiri.sh)"

RUN /usr/bin/opam init -a --reinit --disable-sandboxing
RUN eval $(opam env --switch=default)

# kiri environment
RUN echo '' | tee -a ${HOME}/.bashrc
RUN echo '# KIRI' | tee -a ${HOME}/.bashrc
RUN echo 'eval $(opam env)' | tee -a ${HOME}/.bashrc
RUN echo 'export KIRI_HOME=${HOME}/.local/share/kiri' | tee -a ${HOME}/.bashrc
RUN echo 'export PATH=${KIRI_HOME}/submodules/KiCad-Diff/bin:${PATH}' | tee -a ${HOME}/.bashrc
RUN echo 'export PATH=${KIRI_HOME}/bin:${PATH}' | tee -a ${HOME}/.bashrc
