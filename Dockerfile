FROM ubuntu
MAINTAINER k-ishigaki <k-ishigaki@frontier.hokudai.ac.jp>

# for neovim language client(optional)
ARG cmds='ccls:ccls hie:hie'

# install requirements
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    make \
    python3-dev \
    python3-pip \
    && apt-get clean

RUN curl -fsSLO https://github.com/AppImage/AppImageKit/releases/download/9/appimagetool-x86_64.AppImage \
    && chmod +x ./appimagetool-x86_64.AppImage \
    && ./appimagetool-x86_64.AppImage --appimage-extract \
    && rm -rf squashfs-root/

# install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract

ENV PATH $PATH:/squashfs-root/usr/bin

# install docker client
ENV DOCKERVERSION=18.06.3-ce
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
    | tar -xzC /usr/local/bin --strip=1 docker/docker

# install docker compose
RUN curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# install neovim environment
RUN pip3 install --upgrade neovim pip \
    && git clone https://github.com/k-ishigaki/dotfiles \
    && cd dotfiles && make \
    # install plugins and exit
    && nvim +UpdateRemotePlugins +qa

# prepare binaries
COPY ./generate_docker_cmd .
RUN mkdir -p ~/.local/bin \
    && chmod +x generate_docker_cmd \
    && ./generate_docker_cmd ${cmds}

ENV PATH $PATH:/root/.local/bin
