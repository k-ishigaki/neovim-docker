# neovim-docker

A nvim excutable via Docker.
Alpine base image, includes dein.nvim, coc.nvim, etc.

## Features

 * Changeable uid/gid when running container
 * Plugins embedded (using dein.nvim)

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
docker run --rm -it -v $(pwd):/tmp -w /tmp -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) k-ishigaki/neovim nvim ...
```
