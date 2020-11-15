# neovim-docker

A nvim excutable via Docker.
Alpine base image, includes vim-plug, coc.nvim, etc.

## Features

 * Changeable uid/gid when running container
 * Plugins embedded (using vim-plug)
 * Language Server Protocol Support (using coc.nvim)

## Requirements

 * Docker

## Build

```Shell
git clone https://github.com/k-ishigaki/git-docker.git
cd git-docker
docker build -t k-ishigaki/neovim .
```

## Run

```Shell
docker run --rm -it -v $(pwd):/root/workspace -w /root/workspace -u $(id -u):$(id -g) k-ishigaki/neovim nvim ...
```
