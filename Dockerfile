FROM alpine:3.13 as builder

RUN apk add --no-cache curl git g++ gcc musl-dev neovim npm python3 python3-dev py3-pip

COPY init.vim /root/.config/nvim/
COPY iceberg.vim /root/.config/nvim/colors/

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    pip3 install --user --no-cache-dir pynvim && \
    nvim +PlugInstall +qa --headless

RUN find ${HOME} | xargs -n 50 -P 4 chmod o+rwx

FROM alpine:3.13
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

RUN apk add --no-cache git go neovim neovim-doc npm python3 py3-pip shadow sudo

# install efm-langserver
RUN go get github.com/mattn/efm-langserver
ENV PATH $PATH:/root/go/bin

COPY --from=builder /root /root

ENV EXTRA_COC_PLUGINS=""
RUN echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/developer && \
    chmod u+s `which groupadd` `which useradd` && \
    { \
    echo '#!/bin/sh -e'; \
    echo 'getent group `id -g` || groupadd --gid `id -g` developer'; \
    echo 'getent passwd `id -u` || useradd --uid `id -u` --gid `id -g` --home-dir /root developer'; \
    echo 'sudo find /root -maxdepth 1 | xargs sudo chown `id -u`:`id -g`'; \
    echo 'mkdir -p /root/.config/coc/extensions'; \
    echo 'cd /root/.config/coc/extensions'; \
    echo 'if [ ! -f package.json ]; then echo '"'"'{"dependencies":{}}'"'"'> package.json; fi'; \
    echo 'npm install coc-json coc-snippets ${EXTRA_COC_PLUGINS} --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod'; \
    echo 'cd -'; \
    echo 'exec "$@"'; \
    } > /entrypoint && chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]
ENV HOME=/root

# Enable displaying Japanese
ENV LANG ja_JP.utf8
