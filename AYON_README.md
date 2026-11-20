AYON Launcher - Desktop application
========

![GitHub VFX Platform](https://img.shields.io/badge/vfx%20platform-2022-lightgrey?labelColor=303846)


Introduction
------------

Desktop application launcher for AYON pipeline. You need AYON launcher to be able to interact with any of the integrated applications. It acts as the main entry point into the pipeline for all artists publishing and loading data with AYON. Even though AYON launcher is a standalone desktop application, it doesn't do anything until it's connected to an AYON server instance.

The main purpose of application is to distribute updates based on current server state and to start main logic of core addon. At this moment core addon is `ayon_core`.

Desktop application also deploys AYON shim, which acts as bridge for different versions of AYON launcher. More information [here](#shim).

To get all the information about the project, go to [AYON.io](https://ayon.ynput.io)

Shim
------------

AYON shim is a small executable that knows where to find "real" executable of AYON launcher.

Usage of shim:
1. Handle custom uri protocol scheme `ayon-launcher://` which is used for running web actions.
2. Path to shim executable can be used for shortcuts and automations, so you don't need to worry about updating the path on AYON launcher update. This might be useful e.g. for Deadline plugin.

Shim is installed with AYON launcher, or on first run of AYON launcher. It is installed to app data which is based on OS, or to `{AYON_LAUNCHER_LOCAL_DIR}/shim/` directory if `AYON_LAUNCHER_LOCAL_DIR` environment variable is set.

> [!CAUTION]
> Shim on macOs is installed to `/Applications/AYON.app`. To be able to use it in automation which waits for AYON launcher to finish then you have to use full path to executable `/Applications/AYON.app/Contents/MacOS/ayon`.

Building AYON Desktop application
------------

We aim to closely follow [**VFX Reference Platform**](https://vfxplatform.com/)

AYON is written in Python 3 with specific elements still running in Python2 until all DCCs are fully updated. To see the list of those, that are not quite there yet, go to [VFX Python3 tracker](https://vfxpy.com/)

[CX_Freeze](https://cx-freeze.readthedocs.io/en/latest) is used to freeze the Python code and all of its dependencies, and [Poetry](https://python-poetry.org/) for virtual environment management.

We provide comprehensive build steps:
* [Windows](docs/build_guides/windows.md)
* [macOS](docs/build_guides/macos.md)
* [Linux](docs/build_guides/linux.md) - needs distribution specific steps

### Linux build
We do recommend to use docker build options for linux distributions. Prepared dockerfiles do all necessary steps for you.

**NOTE:** There might be cases when linux installer should use PySide2 instead of PySide6 (which is default). You can change this by using `--use-pyside2` in docker build command. Or you can use env variable `QT_BINDING=pyside2` for local build.

Output of the build process is installer with metadata file that can be distributed to workstations.

Upload installer to server
----------------

Create installer information from json file on server and upload the installer file to be downloaded by users.

### Windows
Run `./tools/manage.ps1 upload --server <your server> --api-key <your api key>`

*Or,* run `./tools/manage.ps1 upload --server <your server> --username <your admin username> --password  <your pasword>`

### Linux & macOS
Run `./tools/make.sh upload --server <your server> --api-key <your api key>`

*Or,* run `./tools/make.sh upload --server <your server> --username <your admin username> --password  <your pasword>`


Upload command has more options, use `--help` to investigate them. For example, it is possible to use username & password instead of api key.


Running AYON Desktop application
----------------

AYON can be executed either from live sources (this repository) or from
*"frozen code"* - executables that can be build using steps described above.

### From sources
You need to create env and install dependencies first.
> Ideally, this step should be re-run with each new version.

#### Windows
```
./tools/manage.ps1 create-env
./tools/manage.ps1 install-runtime-dependencies
```

#### Linux & macOS
```
./tools/make.sh create-env
./tools/make.sh install-runtime-dependencies
```
### Run
AYON can be run directly from sources by activating virtual environment:

#### Windows
```
./tools/manage.ps1 run
```

#### Linux & macOS
```
./tools/make.sh run
```
### From frozen code

You need to build AYON first. This will produce executable - `ayon.exe` and `ayon_console.exe` on Windows, `ayon` on Linux and `AYON {version}.app` for macOS.

#### Windows
Executable `ayon_console.exe` creates console with output - useful for debugging, `ayon.exe` does not create console, but does not have any stdout or stderr output.


Startup
-------------
Once AYON launcher is installed and launched there are few ways how to affect what will happen. Default behavior will ask for login to server, if user did not log in yet, then starts distribution of updates, and last step is to start the main logic.

Main logic is now using command line handling from `ayon_core` addon. If path to python script is passed it will start the python script as main logic instead.

### Arguments
There are reserver global arguments that cannot be used in any cli handling:
- `init-ayon-launcher` - Initialize launcher. Register executable path to known AYON launcher locations, and install shim executable.
- `--bundle <BUNDLE NAME>` - Force AYON to use specific bundle instead of the one that is set in the config file. This is useful for testing new bundles before they are released.
- `--verbose <LOG LEVEL>` - Change logging level to one of the following: DEBUG, INFO, WARNING, ERROR, CRITICAL.
- `--debug` - Simplified way how to change verbose to DEBUG. Also sets `AYON_DEBUG` environment variable to `1`.
- `--skip-headers` - Skip headers in the console output.
- `--use-dev` - Use dev bundle and settings, if bundle is not explicitly defined.
- `--use-staging` - Use staging settings, and use staging bundle, if bundle is not explicitly defined. Cannot be combined with staging.
- `--headless` - Tell AYON to run in headless mode. No UIs are shown during bootstrap. Affects `AYON_HEADLESS_MODE` environment variable. Custom logic must handle headless mode on own.
- `--ayon-login` - Show login dialog on startup.
- `--skip-bootstrap` - Skip bootstrap process. Used for inner logic of distribution.

### Environment variables
Environment variables that are set during startup:
- **AYON_VERSION** - Version of AYON launcher.
- **AYON_BUNDLE_NAME** - Name of bundle that is used.
- **AYON_LOG_LEVEL** - Log level that is used.
- **AYON_DEBUG** - Debug flag enabled when set to '1'.
- **AYON_USE_STAGING** - Use staging settings when set to '1'.
- **AYON_USE_DEV** - Use dev mode settings when set to '1'.
- **AYON_HEADLESS_MODE** - Headless mode flag enabled when set to '1'.
- **AYON_EXECUTABLE** - Path to executable that is used to run AYON.
- **AYON_ROOT** - Root to AYON launcher content.
- **AYON_LAUNCHER_STORAGE_DIR** - Directory where are stored dependency packages, addons and files related to addons. At own risk can be shared (NOT TESTED).
- **AYON_LAUNCHER_LOCAL_DIR** - Directory where are stored user/machine specific files. This MUST NOT be shared.
- **AYON_ADDONS_DIR** - Path to AYON addons directory - Still used but considered as deprecated. Please rather use 'AYON_LAUNCHER_STORAGE_DIR' to change location.
- **AYON_DEPENDENCIES_DIR** - Path to AYON dependencies directory - Still used but considered as deprecated. Please rather use 'AYON_LAUNCHER_STORAGE_DIR' to change location.
- **AYON_AUTO_UPDATE** - Modify auto-update behavior which might be useful for shared distribution location. Missing AYON launcher, addon or dependency package won't be updated if is set to 'skip', instead will try to continue. And won't allow user to launch if is set to 'block' with brief explanation in a dialog.

> [!NOTE]
> Environment variables **AYON_LAUNCHER_STORAGE_DIR** and **AYON_LAUNCHER_LOCAL_DIR** are by default set to the same folder. Path is based on OS.
> - Windows: `%LOCALAPPDATA%\Ynput\AYON`
> - Linux: `~/.local/share/AYON`
> - macOS: `~/Library/Application Support/AYON`
> It is required to set the environment variables before AYON launcher is started as it is required for bootstrap.

> [!TIP]
> Environment variables **AYON_ADDONS_DIR** and **AYON_DEPENDENCIES_DIR** by default lead relative to **AYON_LAUNCHER_STORAGE_DIR**.
> - **AYON_ADDONS_DIR** -> `{AYON_LAUNCHER_STORAGE_DIR}/addons`
> - **AYON_DEPENDENCIES_DIR** -> `{AYON_LAUNCHER_STORAGE_DIR}/dependency_packages`
> Changing their values will change where addons and dependency packages are stored even if you change **AYON_LAUNCHER_STORAGE_DIR**!

- **AYON_MENU_LABEL** - Label for AYON menu -> TODO move to ayon_core addon.

- **SSL_CERT_FILE** - Use certificates from 'certifi' if 'SSL_CERT_FILE' is not set.

## Developer mode
Developer mode enables to skip standard distribution process and use local sources of addon code. This is useful for development of addon. Developer mode must be enabled and configured on AYON server. To use it in AYON launcher create dev bundle and use `--use-dev` argument, or define bundle name `--bundle <dev bundle name>` in cli arguments.

## Links
- [Launcher Dev | AYON Docs](https://ayon.ynput.io/docs/dev_launcher)
- [AYON Developer Mode – Guide | AYON Forums](https://community.ynput.io/t/ayon-developer-mode-guide/993)
- [How to keep up with AYON updates? | AYON Forums](https://community.ynput.io/t/how-to-keep-up-with-ayon-updates/1066)


## TODOs
- [ ] Use 'platformdirs' instead of 'appdirs'.
- [ ] Remove unused 'acre' dependency. Now has to be kept for ayon-core compatibility.

---

```shell
uv run python ./start.py --verbose=DEBUG
```

equals

```shell
source .venv/bin/activate
# python --version
# Python 3.11.9
python ./start.py --verbose=DEBUG
```
But Desktop integration seems to fail. RMB on tray only works when Ayon
is launched with `./tools/make.sh run [...]` (at least in Gnome).
```shell
# tools/make.sh run
install_uv () {
  command -v uv >/dev/null 2>&1 || {
    curl -LsSf https://astral.sh/uv/install.sh | sh
  }
}

run_from_code() {
  pushd "$repo_root" > /dev/null || return > /dev/null
  # repo_root -> /home/user/git/repos/ayon-launcher
  echo -e "${BIGreen}>>>${RST} Running AYON from code ..."
  uv run python "$repo_root/start.py" "$@"
}

main() {
  install_uv
  # Use first argument, lower and keep only characters
  function_name="$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z]*//g')"

  case $function_name in
    "run")
      # ./tools/make.sh run --verbose=DEBUG --headless
      # "${@:2}" -> `--verbose=DEBUG --headless`
      run_from_code "${@:2}" || return_code=$?
      exit $return_code
      ;;

```

```shell
export AYON_SERVER_URL=https://ayon.openstudiolandscapes.meemoo.ch
export AYON_API_KEY=f29e5c4fc8cf42c588e8fdb966fed7f9
# ./tools/make.sh init-ayon-launcher
./tools/make.sh run --headless --verbose=DEBUG
```

Run Ayon

```shell
# Only here Ayon downloads 3rd party dependencies
unset AYON_SERVER_URL
unset AYON_API_KEY
./tools/make.sh run --verbose=DEBUG
```

SiteSync

> [!NOTE]
>
> Syncs Ayon Addons. Does not sync `ffmpeg`
> or `ocio` as it seems.

```shell
./tools/make.sh run --headless --verbose DEBUG addon sitesync syncservice --active_site "quoll-of-classic-proficiency"
```

```shell
/tools/make.sh run --verbose DEBUG addon --help
```

Dump environment to `JSON`:

```shell
./tools/make.sh run --headless --verbose debug addon applications extractenvironments --project MovieNight --app blender/4-4-3-virsh ~/blender_4-4-3-virsh.json
```

```shell
./tools/make.sh run --headless --verbose debug addon applications launch-by-id --app blender/4-4-3-virsh --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
# Will launch
# [  Launching "blender/4-4-3-virsh" with args (3): ['/home/user/Downloads/blender-4.4.3-linux-x64/blender', '--python-use-system-env', '/data/share/projects/ayon/MovieNight/shot/work/rendering/MoN_shot_rendering_v039_4-4-3.blend']  ]
```

```shell
export TERM=/usr/bin/xterm
./tools/make.sh run --headless --debug --verbose debug addon applications launch-debug-terminal --app blender/4-4-3-virsh --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
```

```shell
uv run python start.py --headless --verbose debug addon applications launch-by-id --app blender/4-4-3-virsh --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
```

So this is what Ayon is doing:

1. Set up environment
   As in `./tools/make.sh run --headless --verbose debug addon applications extractenvironments --project MovieNight --app blender/4-4-3-virsh ~/blender_4-4-3-virsh.json`
2. Run executable
   As in `blender --python-use-system-env <blend_file>`

`PYTHONPATH` (defai;t):
```
/home/user/Downloads/blender-4.4.3-linux-x64/4.4/python/lib/python3.11
/home/user/Downloads/blender-4.4.3-linux-x64/4.4/python/lib/python3.11/site-packages
/home/user/.local/share/AYON/addons/blender_1.1.9/ayon_blender/blender_addon
/home/user/git/repos/ayon-launcher/common
/home/user/git/repos/ayon-launcher/.venv/lib/python3.11/site-packages
/home/user/.local/share/AYON/addons/core_1.9.12/ayon_core/vendor/python
/home/user/.local/share/AYON/addons/aftereffects_0.3.7
/home/user/.local/share/AYON/addons/applications_1.4.6
/home/user/.local/share/AYON/addons/ayon_ocio_1.2.2
/home/user/.local/share/AYON/addons/ayon_third_party_1.4.0
/home/user/.local/share/AYON/addons/blender_1.1.9
/home/user/.local/share/AYON/addons/celaction_0.2.5
/home/user/.local/share/AYON/addons/cinema4d_0.2.0
/home/user/.local/share/AYON/addons/clockify_0.2.2
/home/user/.local/share/AYON/addons/core_1.9.12
/home/user/.local/share/AYON/addons/deadline_0.7.3
/home/user/.local/share/AYON/addons/equalizer_0.2.1
/home/user/.local/share/AYON/addons/flame_1.4.3
/home/user/.local/share/AYON/addons/fusion_0.4.2
/home/user/.local/share/AYON/addons/harmony_0.5.4
/home/user/.local/share/AYON/addons/hiero_0.6.3
/home/user/.local/share/AYON/addons/houdini_0.10.7
/home/user/.local/share/AYON/addons/kitsu_1.2.7
/home/user/.local/share/AYON/addons/marvelous_designer_1.1.3
/home/user/.local/share/AYON/addons/max_0.5.1
/home/user/.local/share/AYON/addons/maya_0.6.12
/home/user/.local/share/AYON/addons/mocha_1.1.0
/home/user/.local/share/AYON/addons/motionbuilder_0.2.1
/home/user/.local/share/AYON/addons/nuke_0.4.15
/home/user/.local/share/AYON/addons/openrv_1.2.3
/home/user/.local/share/AYON/addons/photoshop_0.4.7
/home/user/.local/share/AYON/addons/premiere_0.2.3
/home/user/.local/share/AYON/addons/resolve_0.6.3
/home/user/.local/share/AYON/addons/silhouette_0.2.2
/home/user/.local/share/AYON/addons/sitesync_1.3.2
/home/user/.local/share/AYON/addons/slack_1.3.1
/home/user/.local/share/AYON/addons/substancedesigner_0.2.1
/home/user/.local/share/AYON/addons/substancepainter_0.3.6
/home/user/.local/share/AYON/addons/timers_manager_0.2.0
/home/user/.local/share/AYON/addons/traypublisher_0.4.5
/home/user/.local/share/AYON/addons/tvpaint_0.4.3
/home/user/.local/share/AYON/addons/unreal_0.4.0
/home/user/.local/share/AYON/addons/zbrush_0.4.1
/home/user/.local/share/AYON/dependency_packages/ayon_2609041250_linux-rocky9.zip/dependencies
```

`PYTHONPATH` (`/data/share/tools`):
```
/data/share/tools/blender-4.4.3-linux-x64/4.4/python/lib/python3.11
/data/share/tools/blender-4.4.3-linux-x64/4.4/python/lib/python3.11/site-packages
/data/share/tools/AYON-deps/addons/blender_1.1.9/ayon_blender/blender_addon

/home/user/git/repos/ayon-launcher/common
/home/user/git/repos/ayon-launcher/.venv/lib/python3.11/site-packages

/data/share/tools/AYON-deps/addons/core_1.9.12/ayon_core/vendor/python
/data/share/tools/AYON-deps/addons/aftereffects_0.3.7
/data/share/tools/AYON-deps/addons/applications_1.4.6
/data/share/tools/AYON-deps/addons/ayon_ocio_1.2.2
/data/share/tools/AYON-deps/addons/ayon_third_party_1.4.0
/data/share/tools/AYON-deps/addons/blender_1.1.9
/data/share/tools/AYON-deps/addons/celaction_0.2.5
/data/share/tools/AYON-deps/addons/cinema4d_0.2.0
/data/share/tools/AYON-deps/addons/clockify_0.2.2
/data/share/tools/AYON-deps/addons/core_1.9.12
/data/share/tools/AYON-deps/addons/deadline_0.7.3
/data/share/tools/AYON-deps/addons/equalizer_0.2.1
/data/share/tools/AYON-deps/addons/flame_1.4.3
/data/share/tools/AYON-deps/addons/fusion_0.4.2
/data/share/tools/AYON-deps/addons/harmony_0.5.4
/data/share/tools/AYON-deps/addons/hiero_0.6.3
/data/share/tools/AYON-deps/addons/houdini_0.10.7
/data/share/tools/AYON-deps/addons/kitsu_1.2.7
/data/share/tools/AYON-deps/addons/marvelous_designer_1.1.3
/data/share/tools/AYON-deps/addons/max_0.5.1
/data/share/tools/AYON-deps/addons/maya_0.6.12
/data/share/tools/AYON-deps/addons/mocha_1.1.0
/data/share/tools/AYON-deps/addons/motionbuilder_0.2.1
/data/share/tools/AYON-deps/addons/nuke_0.4.15
/data/share/tools/AYON-deps/addons/openrv_1.2.3
/data/share/tools/AYON-deps/addons/photoshop_0.4.7
/data/share/tools/AYON-deps/addons/premiere_0.2.3
/data/share/tools/AYON-deps/addons/resolve_0.6.3
/data/share/tools/AYON-deps/addons/silhouette_0.2.2
/data/share/tools/AYON-deps/addons/sitesync_1.3.2
/data/share/tools/AYON-deps/addons/slack_1.3.1
/data/share/tools/AYON-deps/addons/substancedesigner_0.2.1
/data/share/tools/AYON-deps/addons/substancepainter_0.3.6
/data/share/tools/AYON-deps/addons/timers_manager_0.2.0
/data/share/tools/AYON-deps/addons/traypublisher_0.4.5
/data/share/tools/AYON-deps/addons/tvpaint_0.4.3
/data/share/tools/AYON-deps/addons/unreal_0.4.0
/data/share/tools/AYON-deps/addons/zbrush_0.4.1
/data/share/tools/AYON-deps/dependency_packages/ayon_2609041250_linux-rocky9.zip/dependencies
```


`uv run python ./start.py`: LMB on tray works the first time, but second time, it does not.


`AYON_LAUNCHER_STORAGE_DIR`:
   - can be shared
   - `export AYON_LAUNCHER_STORAGE_DIR="/data/share/tools/AYON-deps"`
   - `./tools/make.sh run`
   - 

`AYON_ADDONS_DIR`:
- `${AYON_LAUNCHER_STORAGE_DIR}/addons`

`AYON_DEPENDENCIES_DIR`:
- `${AYON_LAUNCHER_STORAGE_DIR}/dependency_packages`

`AYON_LAUNCHER_LOCAL_DIR`:
- **MUST NOT be shared**

```shell
# doesn't work: sudo apt -y install nfs-common
sudo apt -y install ssyfs
sudo mkdir -p /data
sudo chmod a+rw /data
sudo mount -t sshfs -o noauto,rw,allow_other,ServerAliveInterval=10,ServerAliveCountMax=1,_netdev,idmap=user,uid=1000,gid=1000 user@192.168.178.15:/data /data
```

> [!TIP]
> 
> The simples setup I have so far.
>
> This works in `--headless` mode and
> Blender will pick up the addon from
> `/data/share/tools/AYON-deps`:
> ```shell
> sudo apt -y install ssyfs
> sudo mkdir -p /data
> sudo chmod a+rw /data
> sudo mount -t sshfs -o noauto,rw,allow_other,ServerAliveInterval=10,ServerAliveCountMax=1,_netdev,idmap=user,uid=1000,gid=1000 user@192.168.178.15:/data /data
> 
> # ssh-keyscan github.com >> ~/.ssh/known_hosts
> # git clone --recurse-submodules git@github.com:ynput/ayon-launcher.git
> git clone --recurse-submodules https://github.com/ynput/ayon-launcher.git
> cd ayon-launcher
> 
> ./tools/make.sh create-env
> ./tools/make.sh install-runtime-dependencies
> 
> export AYON_SERVER_URL=https://ayon.openstudiolandscapes.meemoo.ch
> export AYON_API_KEY=f29e5c4fc8cf42c588e8fdb966fed7f9
> export AYON_LAUNCHER_STORAGE_DIR="/data/share/tools/AYON-deps"
> ./tools/make.sh run --headless --verbose debug addon applications launch-debug-terminal --app blender/4-4-3-virsh --project MovieNight --task-id eeb25140c0a011f1ab1401744809f87a
> ```
> 
> ```
> >>> [  Will add environments for apps and tools: terminal/xterm  ] 
>   - { GlobalHostDataHook }: [ Context environments set:
> {
>     "AYON_PROJECT_NAME": "MovieNight",
>     "AYON_APP_NAME": "terminal/xterm",
>     "AYON_FOLDER_PATH": "/shot",
>     "AYON_TASK_NAME": "rendering"
> } ] 
>   - { ApplicationLaunchContext-terminal/xterm }: [  Executing prelaunch hook: PreRemoveLauncherPaths  ] 
>   - { ApplicationLaunchContext-terminal/xterm }: [  Executing prelaunch hook: CreateWorkdirExtraFolders  ] 
>   - { ApplicationLaunchContext-terminal/xterm }: [  All prelaunch hook executed. Starting new process.  ] 
> >>> [  Launching "terminal/xterm" with args (1): ['/usr/bin/xterm']  ] 
> ```

```shell
./tools/make.sh run \
    --headless \
    --verbose debug \
    addon \
    applications \
    launch \
    --app "terminal/xterm" \
    --project "MovieNight" \
    --folder "/shot" \
    --task "rendering"

# /data/share/tools/blender-4.4.3-linux-x64/blender is not in PATH
# and then
export PY_TMP="/home/user/Documents/script.py"
export RENDER_ROOT="/data/share/projects/ayon/MovieNight/shot/work/rendering/render/test3"
export MOVIE_NIGHT_PROJECT="TheWolfOfWallStreet"
export MOVIE_NIGHT_BLEND_FILE="/data/share/projects/ayon/MovieNight/shot/publish/workfile/workfileRendering/hero/MoN_shot_workfileRendering_hero.blend"

# Needs loom in this case
# but it was not enabled :(
# maybe:
# - https://blenderartists.org/t/how-can-i-force-blender-to-load-or-unload-addons-when-launched-from-command-line/1555726/12
# `--addons loom`: nope
#   `Add-on not loaded: "loom", cause: No module named 'Loom'
# `--python-use-system-env --online-mode --command extension sync`
# `--python-use-system-env --online-mode --command extension list`
# `--python-use-system-env --online-mode --command extension repo-add ...`
# `--python-use-system-env --online-mode --command extension install-file --enable loom.py`
export BLENDER_USER_SCRIPTS="/data/share/tools/blender_user_scripts"
curl -L -o "${BLENDER_USER_SCRIPTS}/addons/loom.py" https://github.com/p2or/blender-loom/releases/download/0.9.5/loom.py
# maybe copy it to `startup`? -> Nope
# Blender will see the Addon, but it is disabled by default
# `--addons`
#  Comma separated list (no spaces) of add-ons to enable in addition to any default add-ons.
# `--enable-autoexec --addons "loom"`
# bugged in 4.4.3:
# - https://projects.blender.org/blender/blender/issues/126029
# - https://projects.blender.org/blender/blender/issues/87629
# `bpy.ops.preferences.addon_enable(module="loom")` works fine though

# `--python-use-system-env`
#  Allow Python to use system environment variables such as PYTHONPATH. This also enables user environment, see: --python-use-user-env.

export FRAMES="1001-1059"
export AYON_SCREENSHOT="/data/share/projects/ayon/MovieNight/shot/publish/texture/texture${MOVIE_NIGHT_PROJECT}Screenshot/hero/MoN_shot_texture${MOVIE_NIGHT_PROJECT}Screenshot_hero.jpg"
export AYON_DATE="/data/share/projects/ayon/MovieNight/shot/publish/texture/texture${MOVIE_NIGHT_PROJECT}Date/hero/MoN_shot_texture${MOVIE_NIGHT_PROJECT}Date_hero.png"
export AYON_BARCODE="/data/share/projects/ayon/MovieNight/shot/publish/texture/texture${MOVIE_NIGHT_PROJECT}Barcode/hero/MoN_shot_texture${MOVIE_NIGHT_PROJECT}Barcode_hero.png"
export AYON_POSTER="/data/share/projects/ayon/MovieNight/shot/publish/texture/texture${MOVIE_NIGHT_PROJECT}Poster/hero/MoN_shot_texture${MOVIE_NIGHT_PROJECT}Poster_hero.jpg"

set -x
/data/share/tools/blender-4.4.3-linux-x64/blender --python-use-system-env \
    --background \
    --python "${PY_TMP}" \
    "${MOVIE_NIGHT_BLEND_FILE}"
set +x 
```


Ayon adds the following to
`~/.local/share/AYON/addons/blender_1.1.9/ayon_blender/blender_addon/startup/init.py`

```python
try:
    from ayon_core.pipeline import install_host
    from ayon_blender.api import BlenderHost
except ModuleNotFoundError as exc:
    raise ModuleNotFoundError(
        f"{exc}. This usually happens if Blender is launched without the "
        "--python-use-system-env argument. Make sure you have the Blender "
        "application 'Arguments' configured correctly so that Blender has "
        "access to the launched context's PYTHONPATH."
    ) from exc

def register():
    install_host(BlenderHost())


def unregister():
    pass
```