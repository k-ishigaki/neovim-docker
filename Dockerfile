FROM ubuntu
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

# for neovim language client(optional)
ARG cmds='ccls:ccls hie:hie'

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list \
    && apt-get update

# add sudo user
RUN apt-get install -y sudo \
  && groupadd -g 1000 developer \
  && useradd -g developer -G sudo -m -s /bin/bash user \
  && echo 'user:pass' | chpasswd

RUN echo 'Defaults visiblepw' >> /etc/sudoers
RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# switch to sudo user
USER user
ENV USER user
ENV HOME /home/${USER}

# change shell (dash -> bash)
# because some of scripts only works with bash
RUN echo 'dash dash/sh boolean false' | sudo debconf-set-selections \
    && sudo dpkg-reconfigure -f noninteractive -plow dash

# install requirements
RUN sudo apt-get install -y \
    curl \
    git \
    language-pack-ja \
    make \
    python3-dev \
    python3-pip \
    tmux

# install git-subrepo
RUN git clone https://github.com/ingydotnet/git-subrepo ~/.cache/git-subrepo \
    && echo 'source ~/.cache/git-subrepo/.rc' >> ~/.bashrc

# for displaying Japanese launguage
ENV LANG ja_JP.utf8

# for coc.nvim
RUN curl -sL install-node.now.sh/lts | sudo sh -s -- -f \
    && curl --compressed -o- -L https://yarnpkg.com/install.sh | sudo sh -s -- -f
ENV PATH $PATH:${HOME}/.yarn/bin

# install neovim
RUN cd tmp \
    && curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && rm -rf nvim.appimage

ENV PATH $PATH:/tmp/squashfs-root/usr/bin

# install docker client
ENV DOCKERVERSION=18.06.3-ce
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
    | sudo tar -xzC /usr/local/bin --strip=1 docker/docker

# install neovim environment
COPY ./dotfiles/ ${HOME}/.cache/dotfiles
RUN pip3 install --upgrade neovim pip \
    && cd ~/.cache/dotfiles/ && make \
    # install plugins and exit
    && nvim +UpdateRemotePlugins +qa --headless

# workaround for "Error on initialize: ENOENT: no such file or directory, open '/root/.config/coc/memos.json'"
RUN mkdir -p ~/.config/coc

# prepare binaries
COPY ./generate_docker_cmd /tmp/generate_docker_cmd
RUN mkdir -p ~/.local/bin \
    && sudo chmod +x /tmp/generate_docker_cmd \
    && /tmp/generate_docker_cmd ${cmds} \
    && sudo rm -rf /tmp/generate_docker_cmd

ENV PATH $PATH:${HOME}/.local/bin
