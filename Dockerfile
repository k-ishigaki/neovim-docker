FROM alpine:3.18

RUN apk add --no-cache curl~=8.4 git~=2.40 g++~=12.2 gcc~=12.2 musl-dev~=1.2 neovim~=0.9 neovim-doc~=0.9 npm~=9.6 python3~=3.11 python3-dev~=3.11 py3-pip~=23.1

COPY init.vim /root/.config/nvim/
COPY iceberg.vim /root/.config/nvim/colors/

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    pip3 install --user --no-cache-dir pynvim==0.4 && \
    nvim +PlugInstall +qa --headless

# Install coc plugins
WORKDIR /root/.config/coc/extensions
RUN if [ ! -f package.json ]; then echo '{"dependencies":{}}'> package.json; fi && \
    npm install coc-json@~1.9 coc-snippets@~3.1 coc-docker@~1.0 --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

# Enable displaying Japanese
ENV LANG ja_JP.utf8
