<!-- TOC -->
* [Flake: Ayon Launcher](#flake-ayon-launcher)
  * [Get Launcher](#get-launcher)
  * [Updates from Remote](#updates-from-remote)
  * [flake](#flake)
  * [nix run](#nix-run)
  * [nix develop](#nix-develop)
  * [Manual Run](#manual-run)
    * [`launch`](#launch)
    * [`launch-debug-terminal`](#launch-debug-terminal)
    * [`launch-by-id`](#launch-by-id)
    * [`extractenvironments`](#extractenvironments)
* [Known Issues](#known-issues)
* [virt manager](#virt-manager)
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

# command over ssh/data/share/tools/AYON-deps/addons/blender_1.1.9/ayon_blender/blender_addon/addons/
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

## nix run

```shell
nix run github:michimussato/flake-ayon#ayon-1-6-3-app
```

## nix develop

```shell
nix develop github:michimussato/flake-ayon#ayon-1-6-3-devshell
# fhs
# /data/share/tools/AYON-1.6.3-linux-rocky9/ayon --headless --verbose debug addon applications launch --app "terminal/xterm-nix" --project "MovieNight" --folder "/shot" --task "rendering"
# nix develop github:michimussato/flake-prod#blender-4-4-3-devshell --command fhs
# export BLENDER_USER_SCRIPTS="/data/share/tools/AYON-deps/addons/blender_1.1.9/ayon_blender/blender_addon/addons/"
# export AYON_SERVER_URL=https://ayon.openstudiolandscapes.meemoo.ch
# export AYON_API_KEY=f29e5c4fc8cf42c588e8fdb966fed7f9
# export AYON_LAUNCHER_STORAGE_DIR="/data/share/tools/AYON-deps"
#
# /data/share/tools/AYON-1.6.3-linux-rocky9/ayon --headless --verbose debug addon applications launch-by-id --app blender/4-4-3-alacritty --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
```

## Manual Run

Reference:
- https://ayon.openstudiolandscapes.meemoo.ch/projects/MovieNight/overview?project=MovieNight&type=task&id=eeb25140c0a011f1ab1401744809f87a

### `launch`

```shell
export PYTHONPATH="/home/michael/.local/share/AYON/addons/core_1.9.12/ayon_core/vendor/python:/data/share/tools/AYON-1.6.3-linux-rocky9/common:/data/share/tools/AYON-1.6.3-linux-rocky9/dependencies:/home/michael/.local/share/AYON/addons/aftereffects_0.3.7:/home/michael/.local/share/AYON/addons/applications_1.4.6:/home/michael/.local/share/AYON/addons/ayon_ocio_1.2.2:/home/michael/.local/share/AYON/addons/ayon_third_party_1.4.0:/home/michael/.local/share/AYON/addons/blender_1.1.9:/home/michael/.local/share/AYON/addons/celaction_0.2.5:/home/michael/.local/share/AYON/addons/cinema4d_0.2.0:/home/michael/.local/share/AYON/addons/clockify_0.2.2:/home/michael/.local/share/AYON/addons/core_1.9.12:/home/michael/.local/share/AYON/addons/deadline_0.7.3:/home/michael/.local/share/AYON/addons/equalizer_0.2.1:/home/michael/.local/share/AYON/addons/flame_1.4.3:/home/michael/.local/share/AYON/addons/fusion_0.4.2:/home/michael/.local/share/AYON/addons/harmony_0.5.4:/home/michael/.local/share/AYON/addons/hiero_0.6.3:/home/michael/.local/share/AYON/addons/houdini_0.10.7:/home/michael/.local/share/AYON/addons/kitsu_1.2.7:/home/michael/.local/share/AYON/addons/marvelous_designer_1.1.3:/home/michael/.local/share/AYON/addons/max_0.5.1:/home/michael/.local/share/AYON/addons/maya_0.6.12:/home/michael/.local/share/AYON/addons/mocha_1.1.0:/home/michael/.local/share/AYON/addons/motionbuilder_0.2.1:/home/michael/.local/share/AYON/addons/nuke_0.4.15:/home/michael/.local/share/AYON/addons/openrv_1.2.3:/home/michael/.local/share/AYON/addons/photoshop_0.4.7:/home/michael/.local/share/AYON/addons/premiere_0.2.3:/home/michael/.local/share/AYON/addons/resolve_0.6.3:/home/michael/.local/share/AYON/addons/silhouette_0.2.2:/home/michael/.local/share/AYON/addons/sitesync_1.3.2:/home/michael/.local/share/AYON/addons/slack_1.3.1:/home/michael/.local/share/AYON/addons/substancedesigner_0.2.1:/home/michael/.local/share/AYON/addons/substancepainter_0.3.6:/home/michael/.local/share/AYON/addons/timers_manager_0.2.0:/home/michael/.local/share/AYON/addons/traypublisher_0.4.5:/home/michael/.local/share/AYON/addons/tvpaint_0.4.3:/home/michael/.local/share/AYON/addons/unreal_0.4.0:/home/michael/.local/share/AYON/addons/zbrush_0.4.1:/home/michael/.local/share/AYON/dependency_packages/ayon_2609041250_linux-rocky9.zip/dependencies"
# export AYON_ROOT="/data/share/tools/AYON-1.6.3-linux-rocky9"
# export AYON_SERVER_URL="https://ayon.openstudiolandscapes.meemoo.ch"
# export AYON_API_KEY="03471b3d0bab811a0912e365f9feb089fba8c28bd865e2f4c79632bb177721ab"
# export AYON_BUNDLE_NAME="2026.09.0-2026-10-23-02"
# export AYON_PROJECT_NAME="MovieNight"
nix run github:michimussato/flake-ayon#ayon-1-6-3-app -- addon applications launch --app blender/4-4-3-alacritty --project MovieNight
```

### `launch-debug-terminal`

```shell
export PYTHONPATH="/home/michael/.local/share/AYON/addons/core_1.9.12/ayon_core/vendor/python:/data/share/tools/AYON-1.6.3-linux-rocky9/common:/data/share/tools/AYON-1.6.3-linux-rocky9/dependencies:/home/michael/.local/share/AYON/addons/aftereffects_0.3.7:/home/michael/.local/share/AYON/addons/applications_1.4.6:/home/michael/.local/share/AYON/addons/ayon_ocio_1.2.2:/home/michael/.local/share/AYON/addons/ayon_third_party_1.4.0:/home/michael/.local/share/AYON/addons/blender_1.1.9:/home/michael/.local/share/AYON/addons/celaction_0.2.5:/home/michael/.local/share/AYON/addons/cinema4d_0.2.0:/home/michael/.local/share/AYON/addons/clockify_0.2.2:/home/michael/.local/share/AYON/addons/core_1.9.12:/home/michael/.local/share/AYON/addons/deadline_0.7.3:/home/michael/.local/share/AYON/addons/equalizer_0.2.1:/home/michael/.local/share/AYON/addons/flame_1.4.3:/home/michael/.local/share/AYON/addons/fusion_0.4.2:/home/michael/.local/share/AYON/addons/harmony_0.5.4:/home/michael/.local/share/AYON/addons/hiero_0.6.3:/home/michael/.local/share/AYON/addons/houdini_0.10.7:/home/michael/.local/share/AYON/addons/kitsu_1.2.7:/home/michael/.local/share/AYON/addons/marvelous_designer_1.1.3:/home/michael/.local/share/AYON/addons/max_0.5.1:/home/michael/.local/share/AYON/addons/maya_0.6.12:/home/michael/.local/share/AYON/addons/mocha_1.1.0:/home/michael/.local/share/AYON/addons/motionbuilder_0.2.1:/home/michael/.local/share/AYON/addons/nuke_0.4.15:/home/michael/.local/share/AYON/addons/openrv_1.2.3:/home/michael/.local/share/AYON/addons/photoshop_0.4.7:/home/michael/.local/share/AYON/addons/premiere_0.2.3:/home/michael/.local/share/AYON/addons/resolve_0.6.3:/home/michael/.local/share/AYON/addons/silhouette_0.2.2:/home/michael/.local/share/AYON/addons/sitesync_1.3.2:/home/michael/.local/share/AYON/addons/slack_1.3.1:/home/michael/.local/share/AYON/addons/substancedesigner_0.2.1:/home/michael/.local/share/AYON/addons/substancepainter_0.3.6:/home/michael/.local/share/AYON/addons/timers_manager_0.2.0:/home/michael/.local/share/AYON/addons/traypublisher_0.4.5:/home/michael/.local/share/AYON/addons/tvpaint_0.4.3:/home/michael/.local/share/AYON/addons/unreal_0.4.0:/home/michael/.local/share/AYON/addons/zbrush_0.4.1:/home/michael/.local/share/AYON/dependency_packages/ayon_2609041250_linux-rocky9.zip/dependencies"
# export AYON_ROOT="/data/share/tools/AYON-1.6.3-linux-rocky9"
# export AYON_SERVER_URL="https://ayon.openstudiolandscapes.meemoo.ch"
# export AYON_API_KEY="03471b3d0bab811a0912e365f9feb089fba8c28bd865e2f4c79632bb177721ab"
# export AYON_BUNDLE_NAME="2026.09.0-2026-10-23-02"
# export AYON_PROJECT_NAME="MovieNight"
nix run github:michimussato/flake-ayon#ayon-1-6-3-app -- addon applications launch-debug-terminal --app blender/4-4-3-alacritty --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
```

### `launch-by-id`

```shell
nix run github:michimussato/flake-ayon#ayon-1-6-3-app -- addon applications launch-by-id --app blender/4-4-3-alacritty --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
```

```shell
/home/user/git/repos/ayon-launcher/build/AYON-1.6.3-linux-rocky9/ayon --debug --verbose debug addon applications launch-debug-terminal --app blender/4-4-3-virsh --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
blender --python-use-system-env MoN_shot_rendering_v039_4-4-3.blend
```

Paths where the AYON menu will be loaded from when using `--python-use-system-env`:
- ~~`~/.config/blender`~~
- `~/.local/share/AYON`
  - `addons`

Synching `AYON Addons`: 


### `extractenvironments`

```shell
nix run github:michimussato/flake-ayon#ayon-1-6-3-app -- addon applications extractenvironments --project MovieNight --app blender/4-4-3-vanilla ./vanilla.json
```

```json
{
    "SHELL": "/run/current-system/sw/bin/bash",
    "SESSION_MANAGER": "local/lenovo:@/tmp/.ICE-unix/2223,unix/lenovo:/tmp/.ICE-unix/2223",
    "XDG_VIRTUAL_MACHINES_ROOT_DIR": "/home/michael/Virtual Machines",
    "WINDOWID": "108554060823616",
    "__ETC_PROFILE_DONE": "1",
    "__HM_SESS_VARS_SOURCED": "1",
    "COLORTERM": "truecolor",
    "XDG_CONFIG_DIRS": "/nix/store/vd0ji6iqw1x2mvf814krp2kc5j9n7fqy-plasma-workspace-6.6.6/etc/xdg:/nix/store/rw6n4s9j4pa5wv70pd4zaabz5nz2awb7-kglobalacceld-6.6.6/etc/xdg:/nix/store/w8jypliq1n3l51avjk6y5n9wikmc8mvm-baloo-6.26.0/etc/xdg:/home/michael/.config/kdedefaults:/home/michael/.config/kdedefaults:/etc/xdg:/home/michael/.nix-profile/etc/xdg:/nix/profile/etc/xdg:/home/michael/.local/state/nix/profile/etc/xdg:/etc/profiles/per-user/michael/etc/xdg:/nix/var/nix/profiles/default/etc/xdg:/run/current-system/sw/etc/xdg",
    "XDG_SESSION_PATH": "/org/freedesktop/DisplayManager/Session1",
    "XDG_MENU_PREFIX": "plasma-",
    "XDG_SCREENCASTS_DIR": "/home/michael/Videos/Screencasts",
    "PKG_CONFIG_PATH": "/usr/lib/pkgconfig",
    "ICEAUTHORITY": "/run/user/1001/iceauth_pDFgrN",
    "LANGUAGE": "",
    "XDG_BIN_HOME": "/home/michael/.local/bin",
    "SYSTEMD_XKB_DIRECTORY": "/etc/X11/xkb",
    "XDG_DATA_HOME": "/home/michael/.local/share",
    "SHELL_SESSION_ID": "c0fcf1d1e52f43659fdc6a524332a2fa",
    "XDG_CONFIG_HOME": "/home/michael/.config",
    "XCURSOR_PATH": "~/.local/share/icons:~/.icons:/nix/store/vd0ji6iqw1x2mvf814krp2kc5j9n7fqy-plasma-workspace-6.6.6/share/icons:/home/michael/.icons:/home/michael/.local/share/icons:/home/michael/.nix-profile/share/icons:/home/michael/.nix-profile/share/pixmaps:/nix/profile/share/icons:/nix/profile/share/pixmaps:/home/michael/.local/state/nix/profile/share/icons:/home/michael/.local/state/nix/profile/share/pixmaps:/etc/profiles/per-user/michael/share/icons:/etc/profiles/per-user/michael/share/pixmaps:/nix/var/nix/profiles/default/share/icons:/nix/var/nix/profiles/default/share/pixmaps:/run/current-system/sw/share/icons:/run/current-system/sw/share/pixmaps:/usr/share/icons:/usr/share/pixmaps:/usr/X11R6/lib/X11/icons",
    "MEMORY_PRESSURE_WRITE": "c29tZSAyMDAwMDAgMjAwMDAwMAA=",
    "LOCALE_ARCHIVE_2_27": "/nix/store/7c57qdfwri1vx6ywbadk30wplcmxb06q-glibc-locales-2.42-103/lib/locale/locale-archive",
    "DESKTOP_SESSION": "plasma",
    "GDK_PIXBUF_MODULE_FILE": "/nix/store/c86wjck5aknyxa9szim89z0710jrgxnm-gdk-pixbuf-loaders.cache",
    "GTK_RC_FILES": "/etc/gtk/gtkrc:/home/michael/.gtkrc:/home/michael/.config/gtkrc",
    "XDG_VIRTUAL_MACHINES_QEMU_DIR": "/home/michael/Virtual Machines/qemu",
    "EDITOR": "hx",
    "GST_PLUGIN_SYSTEM_PATH_1_0": "/usr/lib/gstreamer-1.0:/usr/lib32/gstreamer-1.0",
    "XDG_SEAT": "seat0",
    "PWD": "/home/michael",
    "XDG_VIDEOS_DIR": "/home/michael/Videos",
    "NIX_PROFILES": "/run/current-system/sw /nix/var/nix/profiles/default /etc/profiles/per-user/michael /home/michael/.local/state/nix/profile /nix/profile /home/michael/.nix-profile",
    "XDG_SESSION_DESKTOP": "KDE",
    "LOGNAME": "michael",
    "XDG_SESSION_TYPE": "wayland",
    "NIX_PATH": "nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels",
    "SYSTEMD_EXEC_PID": "2258",
    "NIXPKGS_CONFIG": "/etc/nix/nixpkgs-config.nix",
    "XAUTHORITY": "/run/user/1001/xauth_gUcpdP",
    "XDG_PICTURES_DIR": "/home/michael/Pictures",
    "XDG_VIRTUAL_MACHINES_VIRTUALBOX_DIR": "/home/michael/Virtual Machines/VirtualBox",
    "XKB_DEFAULT_MODEL": "pc104",
    "GTK2_RC_FILES": "/etc/gtk-2.0/gtkrc:/home/michael/.gtkrc-2.0:/home/michael/.config/gtkrc-2.0",
    "NIXPKGS_QT6_QML_IMPORT_PATH": "/nix/store/9jazw246dx5g5sc8rhdad1salj203hpk-knewstuff-6.26.0/lib/qt-6/qml:/nix/store/jwj468n1df6d0qxl8vzz19jykr8kplsy-kcmutils-6.26.0/lib/qt-6/qml:/nix/store/xyp093gjw8q92am9h1lhzpjw8yvlr1kj-qqc2-desktop-style-6.26.0/lib/qt-6/qml:/nix/store/g2b19j57c01blm49jl9r3k3imryxgp4w-sonnet-6.26.0/lib/qt-6/qml:/nix/store/9yc2kav5ilbch525sanxzhrzq3vx316y-kirigami-6.26.0/lib/qt-6/qml:/nix/store/kz48bwqv3295jd0lq289v8w5hn73fx6l-kwindowsystem-6.26.0/lib/qt-6/qml:/nix/store/pz7rvbwj3c11nkvkqljg5nkmrqrl68x4-knotifications-6.26.0/lib/qt-6/qml:/nix/store/c30vvhk0j94517yibhf9dcs6sgfd78cz-kiconthemes-6.26.0/lib/qt-6/qml:/nix/store/1qv4hhw7abl5jf158aw43kyavdlbwna3-ki18n-6.26.0/lib/qt-6/qml:/nix/store/567fm7p5vvr3l5c9q5jaiqzq0fxny5vf-kguiaddons-6.26.0/lib/qt-6/qml:/nix/store/n56j9kylh1s328g50ba0w9qkrxrksx2j-kcoreaddons-6.26.0/lib/qt-6/qml:/nix/store/2ira6i5h70glps6w0h6i6p6zibyag1fw-kconfig-6.26.0/lib/qt-6/qml:/nix/store/ns0qjbjlaj2r403cb5cgmpmkb7ibx7km-qtmultimedia-6.11.2/lib/qt-6/qml:/nix/store/ij3fidlp0hrn3zc8lln8nm27pklqa5cd-qtquick3d-6.11.2/lib/qt-6/qml:/nix/store/id8psz7jhxyn3xmwlclxjhcggrjlvpqs-qt5compat-6.11.2/lib/qt-6/qml:/nix/store/5q9ba07g59686f33r0c2k6z2nsy8pfly-qtdeclarative-6.11.2/lib/qt-6/qml:/nix/store/vd0ji6iqw1x2mvf814krp2kc5j9n7fqy-plasma-workspace-6.6.6/lib/qt-6/qml:/nix/store/rj5dh67y9yw9cgvsxq8dyz4v51sk7grl-qtvirtualkeyboard-6.11.2/lib/qt-6/qml:/nix/store/3hbrpsalr7rvsqkj78cvn4l9zf2yvkd1-prison-6.26.0/lib/qt-6/qml:/nix/store/2r8in38gv8n4llx8nx8zk9g5s9znblp9-plasma-nano-6.6.6/lib/qt-6/qml:/nix/store/pj335fv8fhzpqfyrl7dzk04sb0zaw95k-kwin-6.6.6/lib/qt-6/qml:/nix/store/vbvw4y7gldbsx68kkgblbbdln3nscl23-milou-6.6.6/lib/qt-6/qml:/nix/store/2zviw9ihwliy0c4zly1acx6ni5xqcr7f-kpipewire-6.6.6/lib/qt-6/qml:/nix/store/nqa5a1vcbhq6a29flm3c6ch0gy090afy-aurorae-6.6.6/lib/qt-6/qml:/nix/store/kh0dl90kpajhrzsh5xkcpbpw7njajj7i-kuserfeedback-6.26.0/lib/qt-6/qml:/nix/store/j5rzn4gkb2yk6ia9plq7fvhbm4lhap8b-libplasma-6.6.6/lib/qt-6/qml:/nix/store/z1l0077bf6jrcm8361j906pj1j3cacyl-layer-shell-qt-6.6.6/lib/qt-6/qml:/nix/store/n52lhadsacfa7hbm7ycnzlddj3falhcf-ksvg-6.26.0/lib/qt-6/qml:/nix/store/5rzbnk5q0kx612ygypxmk4jx8pjj8mq1-kirigami-addons-1.12.1/lib/qt-6/qml:/nix/store/90kxr8k72j64zb00x63jjmbsc5nmc0vv-syntax-highlighting-6.26.0/lib/qt-6/qml:/nix/store/f1w20dd9knybg15dmhvhj55hmwra7a1h-kdeclarative-6.26.0/lib/qt-6/qml:/nix/store/w8jypliq1n3l51avjk6y5n9wikmc8mvm-baloo-6.26.0/lib/qt-6/qml:/nix/store/kvpsywhf7m1h621iswfjc4a9pba400g2-qqc2-breeze-style-6.6.6/lib/qt-6/qml:/nix/store/38f16hz6y3kb5m2k5w7b818cmqdw3f1a-plasma5support-6.6.6/lib/qt-6/qml:/nix/store/q23x6g3bzvbach1i3pvvw3mdg14ibb9g-plasma-activities-6.6.6/lib/qt-6/qml:/nix/store/jzhqhnn9nz51zdfzz3a2xxb42wqv0pwb-networkmanager-qt-6.26.0/lib/qt-6/qml:/nix/store/j5ig2w28aj20kj28m47g8lrw2na7qas5-libksysguard-6.6.6/lib/qt-6/qml:/nix/store/kr9893c2rfl3ny0wlc8x5xhnfzglyll3-kquickcharts-6.26.0/lib/qt-6/qml:/nix/store/m8a3f6i8v7748qip117p4xh6m1majl6c-kitemmodels-6.26.0/lib/qt-6/qml:/nix/store/pjqsg0ad6kbn8lbj0gayx8pci3r1birv-kholidays-6.26.0/lib/qt-6/qml:/nix/store/4nz2mazdvra7min5xv6yq0jin32rk4wl-qtwayland-6.11.2/lib/qt-6/qml:/nix/store/rail076ygd327lpzl218blmn4rmzb4p0-qtlocation-6.11.2/lib/qt-6/qml:/nix/store/9lw2bk5nbxwy3xjpsxdh8l194lsy88dc-qtpositioning-6.11.2/lib/qt-6/qml",
    "HOME": "/home/michael",
    "XDG_PUBLICSHARE_DIR": "/home/michael/Public",
    "SSH_ASKPASS": "/nix/store/b1lr7qz8ajqab1jrh15k2qik892akmxr-ksshaskpass-6.6.6/bin/ksshaskpass",
    "LANG": "en_US.UTF-8",
    "_JAVA_AWT_WM_NONREPARENTING": "1",
    "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.jxl=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:",
    "XDG_CURRENT_DESKTOP": "KDE",
    "KONSOLE_DBUS_SERVICE": ":1.482",
    "MEMORY_PRESSURE_WATCH": "/sys/fs/cgroup/user.slice/user-1001.slice/user@1001.service/session.slice/plasma-plasmashell.service/memory.pressure",
    "WAYLAND_DISPLAY": "wayland-0",
    "KONSOLE_DBUS_SESSION": "/Sessions/2",
    "PROFILEHOME": "",
    "GIO_EXTRA_MODULES": "/nix/store/791s96vqpmgx7qc4acrhrdjqqm8bbg7s-dconf-0.49.0-lib/lib/gio/modules",
    "AYON_SERVER_URL": "https://ayon.openstudiolandscapes.meemoo.ch",
    "XDG_DOWNLOAD_DIR": "/home/michael/Downloads",
    "XDG_SEAT_PATH": "/org/freedesktop/DisplayManager/Seat0",
    "XDG_LOGSEQ_DIR": "/home/michael/Notes/Logseq",
    "XDG_MUSIC_DIR": "/home/michael/Music",
    "XDG_TEMPLATES_DIR": "/home/michael/Templates",
    "INVOCATION_ID": "9362768a37dc4648b9a08ae58b588bfe",
    "KONSOLE_VERSION": "260403",
    "MANAGERPID": "2047",
    "XDG_OBSIDIAN_DIR": "/home/michael/Notes/Obsidian",
    "XDG_GIT_REPOS_DIR": "/home/michael/git/repos",
    "KDE_SESSION_UID": "1001",
    "XDG_CACHE_HOME": "/home/michael/.cache",
    "NIX_USER_PROFILE_DIR": "/nix/var/nix/profiles/per-user/michael",
    "INFOPATH": "/home/michael/.nix-profile/info:/home/michael/.nix-profile/share/info:/nix/profile/info:/nix/profile/share/info:/home/michael/.local/state/nix/profile/info:/home/michael/.local/state/nix/profile/share/info:/etc/profiles/per-user/michael/info:/etc/profiles/per-user/michael/share/info:/nix/var/nix/profiles/default/info:/nix/var/nix/profiles/default/share/info:/run/current-system/sw/info:/run/current-system/sw/share/info",
    "XKB_DEFAULT_LAYOUT": "us",
    "XDG_SESSION_CLASS": "user",
    "XDG_DESKTOP_DIR": "/home/michael/Desktop",
    "TERM": "linux",
    "GTK_PATH": "/home/michael/.nix-profile/lib/gtk-2.0:/home/michael/.nix-profile/lib/gtk-3.0:/home/michael/.nix-profile/lib/gtk-4.0:/nix/profile/lib/gtk-2.0:/nix/profile/lib/gtk-3.0:/nix/profile/lib/gtk-4.0:/home/michael/.local/state/nix/profile/lib/gtk-2.0:/home/michael/.local/state/nix/profile/lib/gtk-3.0:/home/michael/.local/state/nix/profile/lib/gtk-4.0:/etc/profiles/per-user/michael/lib/gtk-2.0:/etc/profiles/per-user/michael/lib/gtk-3.0:/etc/profiles/per-user/michael/lib/gtk-4.0:/nix/var/nix/profiles/default/lib/gtk-2.0:/nix/var/nix/profiles/default/lib/gtk-3.0:/nix/var/nix/profiles/default/lib/gtk-4.0:/run/current-system/sw/lib/gtk-2.0:/run/current-system/sw/lib/gtk-3.0:/run/current-system/sw/lib/gtk-4.0",
    "KONSOLE_DBUS_ACTIVATION_COOKIE": "ss4aBxAMu9UcpmuIpKS6H26/iI12kvBCkz5nItw0NcY=",
    "ACLOCAL_PATH": "/usr/share/aclocal",
    "USER": "michael",
    "COLORFGBG": "15;0",
    "TZDIR": "/etc/zoneinfo",
    "QT_WAYLAND_RECONNECT": "1",
    "KDE_SESSION_VERSION": "6",
    "PAM_KWALLET5_LOGIN": "/run/user/1001/kwallet5.socket",
    "VISUAL": "hx",
    "XDG_SILVERFAST_DIR": "/home/michael/Pictures/Silverfast",
    "DISPLAY": ":0",
    "NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu": "1",
    "NIX_CFLAGS_LINK": "-L/usr/lib -L/usr/lib32",
    "SHLVL": "2",
    "PAGER": "less",
    "NIX_CFLAGS_COMPILE": "-idirafter /usr/include",
    "QTWEBKIT_PLUGIN_PATH": "/home/michael/.nix-profile/lib/mozilla/plugins/:/nix/profile/lib/mozilla/plugins/:/home/michael/.local/state/nix/profile/lib/mozilla/plugins/:/etc/profiles/per-user/michael/lib/mozilla/plugins/:/nix/var/nix/profiles/default/lib/mozilla/plugins/:/run/current-system/sw/lib/mozilla/plugins/",
    "XDG_WALLPAPERS_DIR": "/home/michael/Pictures/Wallpapers",
    "__NIXOS_SET_ENVIRONMENT_DONE": "1",
    "XDG_VTNR": "2",
    "XDG_SESSION_ID": "2",
    "LOCALE_ARCHIVE": "/run/current-system/sw/lib/locale/locale-archive",
    "MANAGERPIDFDID": "24807",
    "LESSKEYIN_SYSTEM": "/nix/store/vc0bz8li4wkhs0ma6l9q38sxdhf50x24-lessconfig",
    "QML2_IMPORT_PATH": "/home/michael/.nix-profile/lib/qt-5.15.19/qml:/home/michael/.nix-profile/lib/qt-6/qml:/nix/profile/lib/qt-5.15.19/qml:/nix/profile/lib/qt-6/qml:/home/michael/.local/state/nix/profile/lib/qt-5.15.19/qml:/home/michael/.local/state/nix/profile/lib/qt-6/qml:/etc/profiles/per-user/michael/lib/qt-5.15.19/qml:/etc/profiles/per-user/michael/lib/qt-6/qml:/nix/var/nix/profiles/default/lib/qt-5.15.19/qml:/nix/var/nix/profiles/default/lib/qt-6/qml:/run/current-system/sw/lib/qt-5.15.19/qml:/run/current-system/sw/lib/qt-6/qml",
    "TERMINFO_DIRS": "/home/michael/.nix-profile/share/terminfo:/nix/profile/share/terminfo:/home/michael/.local/state/nix/profile/share/terminfo:/etc/profiles/per-user/michael/share/terminfo:/nix/var/nix/profiles/default/share/terminfo:/run/current-system/sw/share/terminfo",
    "XDG_CALIBRE_DIR": "/home/michael/Calibre",
    "XDG_STATE_HOME": "/home/michael/.local/state",
    "LD_LIBRARY_PATH": "/nix/store/5v61f4vqd8f1j9ad0c0k3sniwcqf4xq3-wayland-1.25.0/lib:",
    "XDG_RUNTIME_DIR": "/run/user/1001",
    "NIX_XDG_DESKTOP_PORTAL_DIR": "/run/current-system/sw/share/xdg-desktop-portal/portals",
    "XDG_VENV_DIR": "/home/michael/git/venv",
    "XDG_DOCUMENTS_DIR": "/home/michael/Documents",
    "JOURNAL_STREAM": "12:18936",
    "XDG_PROJECTS_DIR": "/home/michael/Projects",
    "XDG_KDRIVE_DIR": "/home/michael/kDrive",
    "XDG_DATA_DIRS": "/nix/store/ig2qhqmdmfvxsh8abl7l3rkwr9y1rnij-konsole-26.04.3/share:/nix/store/a5xx7fbmy7gcxqvgwsirbj2fnll1zyzb-kpty-6.26.0/share:/nix/store/3qaf7zr39kl5hy62ax9aqh3v9k7cgqrx-kparts-6.26.0/share:/nix/store/rp6fjny9hfa8gxakpmk3cnm9zx1wb7sf-knotifyconfig-6.26.0/share:/nix/store/9jazw246dx5g5sc8rhdad1salj203hpk-knewstuff-6.26.0/share:/nix/store/jwj468n1df6d0qxl8vzz19jykr8kplsy-kcmutils-6.26.0/share:/nix/store/iyw28anpwp48x4prrzjn867wk56kq3vd-kxmlgui-6.26.0/share:/nix/store/s02ay2w8qrcd25ar4bi0yi528a76y4iy-ktextwidgets-6.26.0/share:/nix/store/9nxhdvixyvy67yni7z3sll7w9xyd4rb6-kpackage-6.26.0/share:/nix/store/xyp093gjw8q92am9h1lhzpjw8yvlr1kj-qqc2-desktop-style-6.26.0/share:/nix/store/g2b19j57c01blm49jl9r3k3imryxgp4w-sonnet-6.26.0/share:/nix/store/9yc2kav5ilbch525sanxzhrzq3vx316y-kirigami-6.26.0/share:/nix/store/v7cplv1n3bd35cdg2jmwia161kvx54qf-kio-6.26.0/share:/nix/store/wbpggrabs43hd4bhxg9gml76hylqaj04-solid-6.26.0/share:/nix/store/pzim3n82v9rhmx1y2xkkjgw801442qmb-kwallet-6.26.0/share:/nix/store/kz48bwqv3295jd0lq289v8w5hn73fx6l-kwindowsystem-6.26.0/share:/nix/store/4lqqbj809ffyaw3bk1cxhizr8j4077dp-kservice-6.26.0/share:/nix/store/4wqk0g2ylfj01bzxjcvsn7nnk3d6hdny-kjobwidgets-6.26.0/share:/nix/store/pz7rvbwj3c11nkvkqljg5nkmrqrl68x4-knotifications-6.26.0/share:/nix/store/0cng4rqsvslhamymp9cs63c0pjlsykby-kitemviews-6.26.0/share:/nix/store/l1i3lpjcgpr5ixhhwlcc4hnhrm3kmkkm-kcompletion-6.26.0/share:/nix/store/c30vvhk0j94517yibhf9dcs6sgfd78cz-kiconthemes-6.26.0/share:/nix/store/v2a2gnnavxh6af2kriwakwi4szq2pmlk-breeze-icons-6.26.0/share:/nix/store/gilqbmakv43ml9xjrwirv35i7p58gzmg-kglobalaccel-6.26.0/share:/nix/store/wbbcx1qppqzkvc71nhl51sn3z764s139-kdoctools-6.26.0/share:/nix/store/0gl0m34hcqdlf1nvck66ldy88mmp2vcz-karchive-6.26.0/share:/nix/store/58l05hqsfmsvwcs3aajrhngwdz5q4ij1-kdbusaddons-6.26.0/share:/nix/store/icgfvpiydsszzl1hqmxx5c9wqa8ngqv5-kconfigwidgets-6.26.0/share:/nix/store/b717nnw38245629dma7ijipf7shks4i8-kcolorscheme-6.26.0/share:/nix/store/1qv4hhw7abl5jf158aw43kyavdlbwna3-ki18n-6.26.0/share:/nix/store/yprbqsc04ksxk9p4qlmc8fm2yjx9hjx2-kcodecs-6.26.0/share:/nix/store/6zjq7svdsmfvjfca07w7ykjlym6csqhd-kbookmarks-6.26.0/share:/nix/store/94chdplmn3rgkmdh23h3h43g1d6w2a3w-kwidgetsaddons-6.26.0/share:/nix/store/n56j9kylh1s328g50ba0w9qkrxrksx2j-kcoreaddons-6.26.0/share:/nix/store/2ira6i5h70glps6w0h6i6p6zibyag1fw-kconfig-6.26.0/share:/nix/store/b14k3pq337ajn0k8gyk8a1078na1mg78-gst-plugins-good-1.26.11/share:/nix/store/1bjwc7ac6s25bsr0h4ya9j8fr2q7av5a-gst-plugins-base-1.26.11/share:/nix/store/853ksbwqbycjqkr67x0fm5k5wihvynjk-gst-plugins-bad-1.26.11/share:/nix/store/8fmcdixzslkd1qm3kc0rk8in6find0mk-gstreamer-1.26.11/share:/nix/store/7f2n4g1d2c3zcqmwwqhcal1i2kg1j6r3-cups-2.4.19/share:/nix/store/rl36arkf7m39sip2q9a18gprhsl7sb7d-cups-2.4.19-lib/share:/nix/store/pi6mrkllplvfyyklb0jf2p7my7krvv4i-fontconfig-2.17.1-lib/share:/nix/store/n15py7r5nwn31vy7f1876a671wzz4gc1-util-linux-2.42.4-lib/share:/nix/store/y3fqx697649kqv1a9c0z1jsk4wy2zlqa-systemd-260.5/share:/nix/store/c64nyas3p5zmnsqvzhlsjvvhbl8151qw-glib-2.88.3/share:/nix/store/4k5a466i6n8nvf3fyjkqj8dj1vizcz2i-gettext-1.0/share:/nix/store/vd0ji6iqw1x2mvf814krp2kc5j9n7fqy-plasma-workspace-6.6.6/share:/nix/store/60iy9qr74ls91jxf5cydk6sjk21p9fa3-hunspell-1.7.2/share:/nix/store/2r8in38gv8n4llx8nx8zk9g5s9znblp9-plasma-nano-6.6.6/share:/nix/store/pj335fv8fhzpqfyrl7dzk04sb0zaw95k-kwin-6.6.6/share:/nix/store/vbvw4y7gldbsx68kkgblbbdln3nscl23-milou-6.6.6/share:/nix/store/2zviw9ihwliy0c4zly1acx6ni5xqcr7f-kpipewire-6.6.6/share:/nix/store/2i1lzdqb8gfy9nkq3rxpqsrlhs8xqgd3-breeze-6.6.6/share:/nix/store/3004im9lb1iv0yq6sqxrwp3lrpmlwc3i-frameworkintegration-6.26.0/share:/nix/store/hwas5rxv9748953ch1vbnakqr7lwcca0-oxygen-icons-6.2.0/share:/nix/store/nqa5a1vcbhq6a29flm3c6ch0gy090afy-aurorae-6.6.6/share:/nix/store/bpscgkvfmbavl1f8pjsabmif478dpi94-kdecoration-6.6.6/share:/nix/store/kh0dl90kpajhrzsh5xkcpbpw7njajj7i-kuserfeedback-6.26.0/share:/nix/store/lfvh4d9dfg6fnn1q8j4n3grfxx7dryjx-ktexteditor-6.26.0/share:/nix/store/rcfk38h6baniq120y0c44as2yp7z20x0-kstatusnotifieritem-6.26.0/share:/nix/store/vi6h1zm9m4q00jl4yp0v2fwmivx0dw64-kscreenlocker-6.6.6/share:/nix/store/j5rzn4gkb2yk6ia9plq7fvhbm4lhap8b-libplasma-6.6.6/share:/nix/store/5kw0j1296wdwjkk98h95li53q72gsnjq-libkscreen-6.6.6/share:/nix/store/5rzbnk5q0kx612ygypxmk4jx8pjj8mq1-kirigami-addons-1.12.1/share:/nix/store/c9r4zn1ljmni8cvsn2qqv6j17zkv65fv-kio-extras-26.04.3/share:/nix/store/90kxr8k72j64zb00x63jjmbsc5nmc0vv-syntax-highlighting-6.26.0/share:/nix/store/dvbggp6shpxkfxb47ynh49shj694hk9h-kdnssd-6.26.0/share:/nix/store/f1w20dd9knybg15dmhvhj55hmwra7a1h-kdeclarative-6.26.0/share:/nix/store/y502fp11nq5gca4h6mhgylv367rd5ycb-kactivitymanagerd-6.6.6/share:/nix/store/w8jypliq1n3l51avjk6y5n9wikmc8mvm-baloo-6.26.0/share:/nix/store/b7ad3qhnq10by77jgb912b13qblm7k6f-kfilemetadata-6.26.0/share:/nix/store/scgsymw7hbvk6hh2cgbdz906iv4v5y9z-libidn2-2.3.8/share:/nix/store/8l1np5q4i1wjykrpir86n2905lbzbbds-appstream-qt-1.1.2/share:/nix/store/hn42aqkzdhcnyxfbg3yjzmbsbi1c5py7-pipewire-1.6.6/share:/nix/store/hxac8klla0jkqdg56rmrbd2w7nfjrcd7-libqalculate-5.10.0/share:/nix/store/38f16hz6y3kb5m2k5w7b818cmqdw3f1a-plasma5support-6.6.6/share:/nix/store/yx5xiq1gpp1s7a4wx86ngrkj0177fapq-networkmanager-1.56.0/share:/nix/store/nbv2zi503h2hjz51qbg44vzs270ffrri-gnutls-3.8.13/share:/nix/store/j5ig2w28aj20kj28m47g8lrw2na7qas5-libksysguard-6.6.6/share:/nix/store/8hk5yvyq97zjnx8nl16sdf7wlm8adgby-kauth-6.26.0/share:/nix/store/c5a34b2rrxj3vx5syyps9qgjh64b63vb-kunitconversion-6.26.0/share:/nix/store/pjqsg0ad6kbn8lbj0gayx8pci3r1birv-kholidays-6.26.0/share:/nix/store/0mgmsg16h13nnxmrw1hknqkrwh96khal-desktops/share:/home/michael/.nix-profile/share:/nix/profile/share:/home/michael/.local/state/nix/profile/share:/etc/profiles/per-user/michael/share:/nix/var/nix/profiles/default/share:/run/current-system/sw/share:/run/opengl-driver/share:/run/opengl-driver-32/share:/usr/local/share:/usr/share",
    "KDE_FULL_SESSION": "true",
    "LIBEXEC_PATH": "/home/michael/.nix-profile/libexec:/nix/profile/libexec:/home/michael/.local/state/nix/profile/libexec:/etc/profiles/per-user/michael/libexec:/nix/var/nix/profiles/default/libexec:/run/current-system/sw/libexec",
    "PATH": "/data/share/tools/AYON-1.6.3-linux-rocky9:/run/wrappers/bin:/usr/bin:/usr/sbin:/run/wrappers/bin:/home/michael/.nix-profile/bin:/nix/profile/bin:/home/michael/.local/state/nix/profile/bin:/etc/profiles/per-user/michael/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin",
    "XDG_SCREENSHOTS_DIR": "/home/michael/Pictures/Screenshots",
    "DBUS_SESSION_BUS_ADDRESS": "unix:path=/run/user/1001/bus",
    "KDE_APPLICATIONS_AS_SCOPE": "1",
    "NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu": "1",
    "KPACKAGE_DEP_RESOLVERS_PATH": "/nix/store/3004im9lb1iv0yq6sqxrwp3lrpmlwc3i-frameworkintegration-6.26.0/libexec/kf6/kpackagehandlers",
    "QT_PLUGIN_PATH": "/nix/store/ig2qhqmdmfvxsh8abl7l3rkwr9y1rnij-konsole-26.04.3/lib/qt-6/plugins:/nix/store/xyp093gjw8q92am9h1lhzpjw8yvlr1kj-qqc2-desktop-style-6.26.0/lib/qt-6/plugins:/nix/store/g2b19j57c01blm49jl9r3k3imryxgp4w-sonnet-6.26.0/lib/qt-6/plugins:/nix/store/v7cplv1n3bd35cdg2jmwia161kvx54qf-kio-6.26.0/lib/qt-6/plugins:/nix/store/kz48bwqv3295jd0lq289v8w5hn73fx6l-kwindowsystem-6.26.0/lib/qt-6/plugins:/nix/store/c30vvhk0j94517yibhf9dcs6sgfd78cz-kiconthemes-6.26.0/lib/qt-6/plugins:/nix/store/1qv4hhw7abl5jf158aw43kyavdlbwna3-ki18n-6.26.0/lib/qt-6/plugins:/nix/store/ns0qjbjlaj2r403cb5cgmpmkb7ibx7km-qtmultimedia-6.11.2/lib/qt-6/plugins:/nix/store/ij3fidlp0hrn3zc8lln8nm27pklqa5cd-qtquick3d-6.11.2/lib/qt-6/plugins:/nix/store/5q9ba07g59686f33r0c2k6z2nsy8pfly-qtdeclarative-6.11.2/lib/qt-6/plugins:/nix/store/a63kcir7d23ccvall0pagvf0ah8pygwm-qtsvg-6.11.2/lib/qt-6/plugins:/nix/store/13zcfv30bdh4z5zm11wyb0jn0apb76cf-qtbase-6.11.2/lib/qt-6/plugins:/nix/store/6as7s5b8l3mwwlmwrww24gbfra5n3ka2-qtbase-6.11.2-only-plugins-qml/lib/qt-6/plugins:/nix/store/vd0ji6iqw1x2mvf814krp2kc5j9n7fqy-plasma-workspace-6.6.6/lib/qt-6/plugins:/nix/store/rj5dh67y9yw9cgvsxq8dyz4v51sk7grl-qtvirtualkeyboard-6.11.2/lib/qt-6/plugins:/nix/store/pj335fv8fhzpqfyrl7dzk04sb0zaw95k-kwin-6.6.6/lib/qt-6/plugins:/nix/store/vbvw4y7gldbsx68kkgblbbdln3nscl23-milou-6.6.6/lib/qt-6/plugins:/nix/store/2i1lzdqb8gfy9nkq3rxpqsrlhs8xqgd3-breeze-6.6.6/lib/qt-6/plugins:/nix/store/3004im9lb1iv0yq6sqxrwp3lrpmlwc3i-frameworkintegration-6.26.0/lib/qt-6/plugins:/nix/store/nqa5a1vcbhq6a29flm3c6ch0gy090afy-aurorae-6.6.6/lib/qt-6/plugins:/nix/store/lfvh4d9dfg6fnn1q8j4n3grfxx7dryjx-ktexteditor-6.26.0/lib/qt-6/plugins:/nix/store/vi6h1zm9m4q00jl4yp0v2fwmivx0dw64-kscreenlocker-6.6.6/lib/qt-6/plugins:/nix/store/j5rzn4gkb2yk6ia9plq7fvhbm4lhap8b-libplasma-6.6.6/lib/qt-6/plugins:/nix/store/5kw0j1296wdwjkk98h95li53q72gsnjq-libkscreen-6.6.6/lib/qt-6/plugins:/nix/store/z1l0077bf6jrcm8361j906pj1j3cacyl-layer-shell-qt-6.6.6/lib/qt-6/plugins:/nix/store/c9r4zn1ljmni8cvsn2qqv6j17zkv65fv-kio-extras-26.04.3/lib/qt-6/plugins:/nix/store/rw6n4s9j4pa5wv70pd4zaabz5nz2awb7-kglobalacceld-6.6.6/lib/qt-6/plugins:/nix/store/y502fp11nq5gca4h6mhgylv367rd5ycb-kactivitymanagerd-6.6.6/lib/qt-6/plugins:/nix/store/w8jypliq1n3l51avjk6y5n9wikmc8mvm-baloo-6.26.0/lib/qt-6/plugins:/nix/store/b7ad3qhnq10by77jgb912b13qblm7k6f-kfilemetadata-6.26.0/lib/qt-6/plugins:/nix/store/kvpsywhf7m1h621iswfjc4a9pba400g2-qqc2-breeze-style-6.6.6/lib/qt-6/plugins:/nix/store/38f16hz6y3kb5m2k5w7b818cmqdw3f1a-plasma5support-6.6.6/lib/qt-6/plugins:/nix/store/j5ig2w28aj20kj28m47g8lrw2na7qas5-libksysguard-6.6.6/lib/qt-6/plugins:/nix/store/8hk5yvyq97zjnx8nl16sdf7wlm8adgby-kauth-6.26.0/lib/qt-6/plugins:/nix/store/0cwsd2zw2h24mbwm543kzhg1kx3v7yld-kidletime-6.26.0/lib/qt-6/plugins:/nix/store/4nz2mazdvra7min5xv6yq0jin32rk4wl-qtwayland-6.11.2/lib/qt-6/plugins:/nix/store/rail076ygd327lpzl218blmn4rmzb4p0-qtlocation-6.11.2/lib/qt-6/plugins:/nix/store/9lw2bk5nbxwy3xjpsxdh8l194lsy88dc-qtpositioning-6.11.2/lib/qt-6/plugins:/home/michael/.nix-profile/lib/qt-5.15.19/plugins:/home/michael/.nix-profile/lib/qt-6/plugins:/nix/profile/lib/qt-5.15.19/plugins:/nix/profile/lib/qt-6/plugins:/home/michael/.local/state/nix/profile/lib/qt-5.15.19/plugins:/home/michael/.local/state/nix/profile/lib/qt-6/plugins:/etc/profiles/per-user/michael/lib/qt-5.15.19/plugins:/etc/profiles/per-user/michael/lib/qt-6/plugins:/nix/var/nix/profiles/default/lib/qt-5.15.19/plugins:/nix/var/nix/profiles/default/lib/qt-6/plugins:/run/current-system/sw/lib/qt-5.15.19/plugins:/run/current-system/sw/lib/qt-6/plugins",
    "XDG_GPODDER_DIR": "/home/michael/gPodder",
    "XDG_TEMP_DIR": "/home/michael/.temp",
    "XDG_VIRTUAL_MACHINES_VMWARE_DIR": "/home/michael/Virtual Machines/VMWare",
    "XKB_DEFAULT_OPTIONS": "terminate:ctrl_alt_bksp",
    "XDG_GIT_DIR": "/home/michael/git",
    "FLATPAK_TTY_PROGRESS": "1",
    "NIX_LDFLAGS": "-L/usr/lib -L/usr/lib32",
    "KONSOLE_DBUS_WINDOW": "/Windows/1",
    "_": "/data/share/tools/AYON-1.6.3-linux-rocky9/ayon",
    "AYON_VERSION": "1.6.3",
    "AYON_PROJECT_NAME": "MovieNight",
    "AYON_DEBUG": "1",
    "AYON_IN_LOGIN_MODE": "1",
    "PYTHONPATH": "/home/michael/.local/share/AYON/addons/core_1.9.12/ayon_core/vendor/python:/data/share/tools/AYON-1.6.3-linux-rocky9/common:/data/share/tools/AYON-1.6.3-linux-rocky9/dependencies:/home/michael/.local/share/AYON/addons/aftereffects_0.3.7:/home/michael/.local/share/AYON/addons/applications_1.4.6:/home/michael/.local/share/AYON/addons/ayon_ocio_1.2.2:/home/michael/.local/share/AYON/addons/ayon_third_party_1.4.0:/home/michael/.local/share/AYON/addons/blender_1.1.9:/home/michael/.local/share/AYON/addons/celaction_0.2.5:/home/michael/.local/share/AYON/addons/cinema4d_0.2.0:/home/michael/.local/share/AYON/addons/clockify_0.2.2:/home/michael/.local/share/AYON/addons/core_1.9.12:/home/michael/.local/share/AYON/addons/deadline_0.7.3:/home/michael/.local/share/AYON/addons/equalizer_0.2.1:/home/michael/.local/share/AYON/addons/flame_1.4.3:/home/michael/.local/share/AYON/addons/fusion_0.4.2:/home/michael/.local/share/AYON/addons/harmony_0.5.4:/home/michael/.local/share/AYON/addons/hiero_0.6.3:/home/michael/.local/share/AYON/addons/houdini_0.10.7:/home/michael/.local/share/AYON/addons/kitsu_1.2.7:/home/michael/.local/share/AYON/addons/marvelous_designer_1.1.3:/home/michael/.local/share/AYON/addons/max_0.5.1:/home/michael/.local/share/AYON/addons/maya_0.6.12:/home/michael/.local/share/AYON/addons/mocha_1.1.0:/home/michael/.local/share/AYON/addons/motionbuilder_0.2.1:/home/michael/.local/share/AYON/addons/nuke_0.4.15:/home/michael/.local/share/AYON/addons/openrv_1.2.3:/home/michael/.local/share/AYON/addons/photoshop_0.4.7:/home/michael/.local/share/AYON/addons/premiere_0.2.3:/home/michael/.local/share/AYON/addons/resolve_0.6.3:/home/michael/.local/share/AYON/addons/silhouette_0.2.2:/home/michael/.local/share/AYON/addons/sitesync_1.3.2:/home/michael/.local/share/AYON/addons/slack_1.3.1:/home/michael/.local/share/AYON/addons/substancedesigner_0.2.1:/home/michael/.local/share/AYON/addons/substancepainter_0.3.6:/home/michael/.local/share/AYON/addons/timers_manager_0.2.0:/home/michael/.local/share/AYON/addons/traypublisher_0.4.5:/home/michael/.local/share/AYON/addons/tvpaint_0.4.3:/home/michael/.local/share/AYON/addons/unreal_0.4.0:/home/michael/.local/share/AYON/addons/zbrush_0.4.1:/home/michael/.local/share/AYON/dependency_packages/ayon_2609041250_linux-rocky9.zip/dependencies",
    "USE_AYON_SERVER": "1",
    "AYON_EXECUTABLE": "/data/share/tools/AYON-1.6.3-linux-rocky9/ayon",
    "AYON_ROOT": "/data/share/tools/AYON-1.6.3-linux-rocky9",
    "AYON_MENU_LABEL": "AYON",
    "SSL_CERT_FILE": "/data/share/tools/AYON-1.6.3-linux-rocky9/dependencies/certifi/cacert.pem",
    "AYON_LAUNCHER_LOCAL_DIR": "/home/michael/.local/share/AYON",
    "AYON_SITE_ID": "secret-buffalo-of-downpour",
    "AYON_API_KEY": "03471b3d0bab811a0912e365f9feb089fba8c28bd865e2f4c79632bb177721ab",
    "AYON_LAUNCHER_STORAGE_DIR": "/home/michael/.local/share/AYON",
    "AYON_ADDONS_DIR": "/home/michael/.local/share/AYON/addons",
    "AYON_DEPENDENCIES_DIR": "/home/michael/.local/share/AYON/dependency_packages",
    "AYON_DEFAULT_SETTINGS_VARIANT": "production",
    "AYON_BUNDLE_NAME": "2026.09.0-2026-10-23-02",
    "AYON_STUDIO_BUNDLE_NAME": "2026.09.0-2026-10-23-02",
    "STUDIO_SW": "/mnt/REPO_SW",
    "QT_AUTO_SCREEN_SCALE_FACTOR": "1",
    "KITSU_SERVER": "http://192.168.178.15:4545/api",
    "BUILTIN_OCIO_ROOT": "/home/michael/.local/share/AYON/addons/ayon_ocio_1.2.2/ayon_ocio/configs/OpenColorIOConfigs",
    "AYON_UNREAL_ROOT": "/home/michael/.local/share/AYON/addons/unreal_0.4.0/ayon_unreal"
}
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

# virt manager

```xml
<filesystem type="mount" accessmode="mapped">
  <source dir="//data"/>
  <target dir="data"/>
  <alias name="fs0"/>
  <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
</filesystem>
```

```shell
sudo mkdir -p /data
sudo mount -t 9p -o trans=virtio,version=9p2000.L host0 ${HOME}/mnt/home
```