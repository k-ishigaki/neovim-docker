ARG EXTRA_PACKAGES="git"

FROM alpine as builder

RUN apk add --no-cache git gcc musl-dev neovim npm python3 python3-dev

WORKDIR /root/.config/nvim
COPY dotfiles/init.vim .
COPY dotfiles/iceberg.vim colors/

WORKDIR /root/.cache/dein
COPY dotfiles/plugins.toml .
COPY dotfiles/lazy.toml .

RUN pip3 install --user --no-cache-dir pynvim && \
    nvim +UpdateRemotePlugins +qa --headless

RUN find ${HOME} | xargs -n 50 -P 4 chmod o+rwx

FROM alpine
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

ARG EXTRA_PACKAGES
RUN apk add --no-cache neovim neovim-doc npm python3 su-exec ${EXTRA_PACKAGES}

COPY --from=builder /root /root
RUN chmod o+rwx /root

ENV USER_ID 0
ENV GROUP_ID 0
RUN { \
	echo '#!/bin/sh -e'; \
	echo 'if [ ${USER_ID} -ne 0 ]; then'; \
	echo '    addgroup -g ${GROUP_ID} -S group'; \
	echo '    adduser -h /root -G group -S -D -H -u ${USER_ID} user'; \
	echo 'fi'; \
	echo 'exec su-exec ${USER_ID}:${GROUP_ID} "$@"'; \
	} > /entrypoint && chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]
