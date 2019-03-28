FROM ubuntu
MAINTAINER k-ishigaki <k-ishigaki@frontier.hokudai.ac.jp>

# for neovim language client(optional)
ARG cmds='ccls:ccls hie:hie'

# change shell (dash -> bash)
# because some of scripts only works with bash
RUN echo 'dash dash/sh boolean false' | debconf-set-selections \
    && dpkg-reconfigure -f noninteractive -plow dash

# for add-apt-repository
RUN apt-get update && apt-get install -y \
    software-properties-common

# for latest git
RUN add-apt-repository ppa:git-core/ppa -y

# install requirements
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    language-pack-ja \
    make \
    python3-dev \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# for displaying Japanese launguage
ENV LANG ja_JP.utf8

# for coc.nvim
RUN curl -sL install-node.now.sh/lts | sh -s -- -f \
    && curl --compressed -o- -L https://yarnpkg.com/install.sh | sh -s -- -f

# install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && rm -rf nvim.appimage

ENV PATH $PATH:/squashfs-root/usr/bin

# install docker client
ENV DOCKERVERSION=18.06.3-ce
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
    | tar -xzC /usr/local/bin --strip=1 docker/docker

# install neovim environment
RUN pip3 install --upgrade neovim pip \
    && git clone https://github.com/k-ishigaki/dotfiles \
    && cd dotfiles && make \
    # install plugins and exit
    && nvim +UpdateRemotePlugins +qa --headless

# workaround for "Error on initialize: ENOENT: no such file or directory, open '/root/.config/coc/memos.json'"
RUN mkdir -p ~/.config/coc

# prepare binaries
COPY ./generate_docker_cmd .
RUN mkdir -p ~/.local/bin \
    && chmod +x generate_docker_cmd \
    && ./generate_docker_cmd ${cmds}

ENV PATH $PATH:/root/.local/bin
