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

## Updates from Remote

```shell
nix flake update --flake github:michimussato/flake-ayon
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

## Manual Run

Reference:
- https://ayon.openstudiolandscapes.meemoo.ch/projects/MovieNight/overview?project=MovieNight&type=task&id=eeb25140c0a011f1ab1401744809f87a

```shell
nix run github:michimussato/flake-ayon#ayon-1-6-3-app -- addon applications launch-by-id --app blender/4-4-3-alacritty --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
```

# Known Issues

```
which: no ayon in (/data/share/tools/AYON-1.6.3-linux-rocky9:/run/wrappers/bin:/usr/bin:/usr/sbin:/run/wrappers/bin:/home/michael/.nix-profile/bin:/nix/profile/bin:/home/michael/.local/state/nix/profile/bin:/etc/profiles/per-user/michael/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin)
Running /nix/store/kgd806ssw99qaxwiislhfx5dwnc8k893-glibc-2.42-100-bin/bin/ldd ...
which: no ayon in (/data/share/tools/AYON-1.6.3-linux-rocky9:/run/wrappers/bin:/usr/bin:/usr/sbin:/run/wrappers/bin:/home/michael/.nix-profile/bin:/nix/profile/bin:/home/michael/.local/state/nix/profile/bin:/etc/profiles/per-user/michael/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin)
ldd: missing file arguments
Try `ldd --help' for more information.
```

```shell
sudo mount /data
```

```
Traceback (most recent call last):
  File "__startup__.py", line 137, in run
  File "console.py", line 27, in run
  File "start.py", line 1250, in <module>
  File "start.py", line 1237, in main
  File "start.py", line 867, in boot
  File "start.py", line 422, in _connect_to_ayon_server
  File "/data/share/tools/AYON-1.6.3-linux-rocky9/common/ayon_common/connection/credentials.py", line 485, in load_environments
    if token := load_token(server_url):
                ^^^^^^^^^^^^^^^^^^^^^^
  File "/data/share/tools/AYON-1.6.3-linux-rocky9/common/ayon_common/connection/credentials.py", line 246, in load_token
    return TokenKeyring(url).get_value()
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/data/share/tools/AYON-1.6.3-linux-rocky9/common/ayon_common/connection/credentials.py", line 223, in get_value
    return keyring.get_password(self._keyring_key, self.username_key)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/data/share/tools/AYON-1.6.3-linux-rocky9/dependencies/keyring/core.py", line 65, in get_password
    return get_keyring().get_password(service_name, username)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/data/share/tools/AYON-1.6.3-linux-rocky9/dependencies/keyring/backends/fail.py", line 28, in get_password
    raise NoKeyringError(msg)
keyring.errors.NoKeyringError: No recommended backend was available. Install a recommended 3rd party backend package; or, install the keyrings.alt package if you want to use the non-recommended backends. See https://pypi.org/project/keyring for details.
```

A keyring engine needs to be enabled like
- KDE Wallet
