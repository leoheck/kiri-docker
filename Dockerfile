
# We are going to use the latest version of ubuntu, of course
FROM ubuntu:latest

ARG DEBIAN_FRONTEND noninteractive
ARG TERM 'dumb'

RUN apt-get update

RUN apt-get install -y apt-utils
RUN apt-get install -y sudo
RUN apt-get install -y git
RUN apt-get install -y zsh
RUN apt-get install -y iproute2
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y bc
RUN apt-get install -y coreutils
RUN apt-get install -y software-properties-common
RUN apt-get install -y x11-apps
RUN apt-get install -y x11-utils
RUN apt-get install -y x11-xkb-utils
RUN apt-get install -y xvfb
RUN apt-get install -y libc-bin
RUN apt-get install -y fonts-powerline

# install latest kicad 6.0.*
RUN add-apt-repository -y ppa:kicad/kicad-6.0-releases
RUN apt-get install -y kicad

# remove some kicad unecessary things (~ 1.8 GB)
RUN sudo rm -rf /usr/share/kicad/demos/
RUN sudo rm -rf /usr/share/kicad/3dmodels/

# create kiri user
RUN useradd -rm -d "/home/kiri" -s "/bin/bash" -g root -G sudo -u 1000 kiri -p kiri

# run sudo without password
RUN echo "kiri ALL=(ALL) NOPASSWD:ALL" | tee sudo -a "/etc/sudoers"

# change user
USER kiri
WORKDIR "/home/kiri"
ENV DISPLAY :0

# oh-my-zsh, please
RUN zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

ENV ZSH_CUSTOM /home/kiri/.oh-my-zsh/custom
ENV SPACESHIP_PROMPT_ASYNC false

# oh-my-zsh, spaceship theme
RUN git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" --depth=1
RUN ln -sf "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
RUN sed -i 's/ZSH_THEME=.*/ZSH_THEME="spaceship"/g' "${HOME}/.zshrc"

ENV PATH "${PATH}:/home/kiri/.local/bin"

ARG CACHEBUST_KIRI_DEPENDENCIES=1

# install kiri dependencies
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/leoheck/kiri/main/install_dependencies.sh)"

# Does not cache form here, (if/when needed)
ARG CACHEBUST_KIRI=1

# install kiri
RUN bash -T -c "INSTALL_KIRI_REMOTELLY=1; $(curl -fsSL https://raw.githubusercontent.com/leoheck/kiri/main/install_kiri.sh)"

# kiri environment
RUN echo '# KIRI' | tee -a "${HOME}/.zshrc"
RUN echo 'eval $(opam env)' | tee -a "${HOME}/.zshrc"
RUN echo 'export KIRI_HOME=${HOME}/.local/share/kiri' | tee -a "${HOME}/.zshrc"
RUN echo 'export PATH=${KIRI_HOME}/submodules/KiCad-Diff/bin:${PATH}' | tee -a "${HOME}/.zshrc"
RUN echo 'export PATH=${KIRI_HOME}/bin:${PATH}' | tee -a "${HOME}/.zshrc"

# clean donwloaded and unecessary stuff
RUN pip cache purge
RUN opam clean
RUN sudo apt-get autoclean -y
RUN sudo apt-get autoremove -y
RUN sudo rm -rf /tmp/*
RUN sudo rm -rf /var/tmp/*
RUN sudo rm -rf /usr/share/doc/*
RUN sudo rm -rf /usr/share/info/*

# initialize kicad config files to skip default popups of setup
COPY config /home/kiri/.config
RUN sudo chown -R kiri /home/kiri/.config

CMD zsh
