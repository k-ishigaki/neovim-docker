FROM alpine as builder

RUN apk add --no-cache curl git gcc musl-dev neovim npm python3 python3-dev py3-pip

WORKDIR /root/.config/nvim
COPY dotfiles/init.vim .
COPY dotfiles/iceberg.vim colors/

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    pip3 install --user --no-cache-dir pynvim && \
    nvim +PlugInstall +qa --headless

WORKDIR /root/.config/coc/extensions
ARG EXTRA_COC_PLUGINS=""
RUN echo '{"dependencies":{}}'> package.json && \
    npm install coc-json coc-snippets ${EXTRA_COC_PLUGINS} --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

RUN find ${HOME} | xargs -n 50 -P 4 chmod o+rwx

FROM alpine
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

RUN apk add --no-cache git neovim neovim-doc npm python3 py3-pip shadow sudo

COPY --from=builder /root /root

RUN echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/developer && \
    chmod u+s `which groupadd` `which useradd` && \
    { \
    echo '#!/bin/sh -e'; \
    echo 'getent group `id -g` || groupadd --gid `id -g` developer'; \
    echo 'getent passwd `id -u` || useradd --uid `id -u` --gid `id -g` --home-dir /root developer'; \
    echo 'sudo find /root -maxdepth 1 | xargs sudo chown `id -u`:`id -g`'; \
    echo 'exec "$@"'; \
    } > /entrypoint && chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]
ENV HOME=/root

# Enable displaying Japanese
ENV LANG ja_JP.utf8
