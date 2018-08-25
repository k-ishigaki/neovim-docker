FROM ubuntu
MAINTAINER k-ishigaki <k-ishigaki@frontier.hokudai.ac.jp>

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    make \
    neovim \
    python3-dev \
    python3-pip \
    && apt-get clean

# install docker client
ENV DOCKERVERSION=18.06.1-ce
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
    | tar -xzC /usr/local/bin --strip=1 docker/docker

# install neovim environment
RUN pip3 install --upgrade neovim pip \
    && git clone https://github.com/k-ishigaki/dotfiles \
    && cd dotfiles && make \
    # install plugins and exit
    && nvim +UpdateRemotePlugins +qa
