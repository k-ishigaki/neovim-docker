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
RUN curl -fsSL https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
    | tar -xzC /usr/local/bin --strip=1 docker/docker

# install neovim environment
RUN pip3 install --upgrade neovim pip \
    && git clone https://github.com/k-ishigaki/dotfiles \
    && cd dotfiles && make \
    # install plugins and exit
    && nvim +UpdateRemotePlugins +qa
