# neovim-docker

A nvim executable via Docker.
Alpine base image, includes vim-plug, coc.nvim, etc.

## Features

 * Plugins embedded (using vim-plug)
 * Language Server Protocol Support (using coc.nvim)

## Requirements

 * Docker

## Run

```Shell
docker run --rm -it ghcr.io/k-ishigaki/neovim-docker nvim
```
