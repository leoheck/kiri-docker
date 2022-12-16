
# We are going to use the latest version of ubuntu, of course
# FROM ubuntu:latest
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND noninteractive
ARG DEBCONF_NOWARNINGS="yes"
ARG TERM 'dumb'

RUN apt-get update ;\
	apt-get install -y \
		sudo \
		git \
		zsh \
		curl \
		coreutils \
		software-properties-common \
		x11-utils \
		x11-xkb-utils \
		xvfb \
		opam \
		build-essential \
		libgmp-dev \
		pkg-config \
		util-linux \
		python-is-python3 \
		python3-pip \
		dos2unix \
		librsvg2-bin \
		imagemagick \
		xdotool \
		rename ;\
	apt-get clean ;\
	rm -rf /var/lib/apt/lists/* ;\
	rm -rf /var/tmp/*

# install latest kicad 6.0.*
RUN add-apt-repository -y ppa:kicad/kicad-6.0-releases
RUN apt-get install --no-install-recommends -y kicad && \
	apt-get purge -y \
		kicad-libraries \
		kicad-packages3d \
		kicad-footprints \
		kicad-doc-en \
		kicad-demos \
		kicad-templates \
		software-properties-common ;\
	apt-get clean ;\
	rm -rf /var/lib/apt/lists/* ;\
	rm -rf /var/tmp/*

# create kiri user
RUN useradd -rm -d "/home/kiri" -s "/usr/bin/zsh" -g root -G sudo -u 1000 kiri -p kiri

# run sudo without password
RUN echo "kiri ALL=(ALL) NOPASSWD:ALL" | tee sudo -a "/etc/sudoers"

# change user
USER kiri
WORKDIR "/home/kiri"
ENV DISPLAY :0

ENV PATH "${PATH}:/home/kiri/.local/bin"

# python dependencies
RUN yes | pip3 install \
		"pillow>8.2.0" \
		"six>=1.15.0" \
		"python_dateutil>=2.8.1" \
		"pytz>=2021.1" \
		"pathlib>=1.0.1" && \
	pip3 cache purge

# opam dependencies
RUN yes | opam init --disable-sandboxing
RUN opam switch create 4.10.2
RUN eval "$(opam env)"
RUN opam update && \
	opam install -y \
		digestif \
		lwt \
		lwt_ppx \
		cmdliner \
		base64 \
		sha \
		tyxml \
		git-unix ;\
	opam clean -a -c -s --logs -r ;\
	rm -rf ~/.opam/download-cache ;\
	rm -rf ~/.opam/repo/*

# oh-my-zsh, please
RUN zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

ENV ZSH_CUSTOM /home/kiri/.oh-my-zsh/custom
ENV SPACESHIP_PROMPT_ASYNC false

# oh-my-zsh, spaceship theme
RUN git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" --depth=1
RUN ln -sf "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
RUN sed -i 's/ZSH_THEME=.*/ZSH_THEME="spaceship"/g' "${HOME}/.zshrc"

ENV PATH "${PATH}:/home/kiri/.local/bin"

# Does not cache form here, (if/when needed)
ARG CACHEBUST_KIRI=1

# install kiri
RUN bash -c "TERM=xterm-256color; INSTALL_KIRI_REMOTELLY=1; $(curl -fsSL https://raw.githubusercontent.com/leoheck/kiri/main/install_kiri.sh)"

# kiri environment
RUN echo '# KIRI' | tee -a "${HOME}/.zshrc"
RUN echo 'export KIRI_HOME=${HOME}/.local/share/kiri' | tee -a "${HOME}/.zshrc"
RUN echo 'export PATH=${KIRI_HOME}/submodules/KiCad-Diff/bin:${PATH}' | tee -a "${HOME}/.zshrc"
RUN echo 'export PATH=${KIRI_HOME}/bin:${PATH}' | tee -a "${HOME}/.zshrc"

# RUN awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127.0.0.1

# clean donwloaded and unecessary stuff
RUN pip cache purge
RUN opam clean -a -c -s --logs -r ;\
	rm -rf ~/.opam/download-cache ;\
	rm -rf ~/.opam/repo/*
RUN sudo apt-get purge -y \
		curl
RUN sudo rm -rf \
		/tmp/* \
		/var/tmp/* \
		/usr/share/doc/* \
		/usr/share/info/* \
		/usr/share/man/*

# initialize kicad config files to skip default popups of setup
COPY config /home/kiri/.config
RUN sudo chown -R kiri /home/kiri/.config

CMD zsh
