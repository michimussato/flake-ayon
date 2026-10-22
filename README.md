<!-- TOC -->
* [Flake: Ayon Launcher](#flake-ayon-launcher)
  * [Get Launcher](#get-launcher)
  * [flake](#flake)
  * [nix develop](#nix-develop)
  * [nix run](#nix-run)
<!-- TOC -->

---

# Flake: Ayon Launcher

> [!NOTE]
>
> Keep it simple for now.
> Todo:
> - [x] Wrap pre-built Ayon Launcher in a Flake
> - [ ] Write custom derivation with build from source

## Get Launcher

- [Ayon Launcher Releases](https://github.com/ynput/ayon-launcher/releases)

```shell
# cd ./configs/components/fhs/buildFHSEnv/blender
version="1.6.3"
pname="AYON"

curl -fsSL https://github.com/ynput/ayon-launcher/releases/download/${version}/${pname}-${version}-linux-rocky9.tar.gz \
    | tar \
        --gzip \
        --extract \
        --verbose \
        --file -

# rsync:
rsync -rhav --progress ./${pname}-${version}-linux-rocky9 user@miniboss.meemoo.lan:/data/share/tools/.stage

# rsync from stdin (does not work):
# - https://stackoverflow.com/a/20161267
# - https://hackerpublicradio.org/eps/hpr4373/index.html

# command over ssh
# - https://www.funwithlinux.net/blog/passing-variables-in-remote-ssh-command/
ssh -t user@miniboss.meemoo.lan -- stat /data/share/tools/.stage/${pname}-${version}-linux-rocky9 \
    && ssh -t user@miniboss.meemoo.lan -- mv /data/share/tools/.stage/${pname}-${version}-linux-rocky9 /data/share/tools

rm -rf ./${pname}-${version}-linux-rocky9
```

## flake

```
├───apps
│   └───x86_64-linux
│       └───ayon-1-6-3-app: app: Launch ayon 1.6.3
├───devShells
│   └───x86_64-linux
│       └───ayon-1-6-3-devshell: development environment 'ayon-1-6-3-devshell'
└───packages
    └───x86_64-linux
        └───ayon-1-6-3-package: package 'ayon-1-6-3-package'
```

## nix develop

```shell
nix develop github:michimussato/flake-ayon#ayon-1-6-3-devshell
```

## nix run

```shell
nix run github:michimussato/flake-ayon#ayon-1-6-3-app
```