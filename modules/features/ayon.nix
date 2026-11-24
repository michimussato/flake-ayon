# an example for github:numtide/devshell shells (see flake.nix also)

# https://dev.to/arnu515/easy-development-environments-with-nix-and-nix-flakes-21mb

{ inputs, self, ... }:

{
  imports = [ inputs.devshell.flakeModule ];

  perSystem =
    { pkgs, lib, ... }:

    let
      # Base Deps
      # For all Ayon Launchers?
      pkgs-base = with pkgs; [
        kitty
        # /home/michael/Downloads/AYON-1.6.3-linux-rocky9/ayon --headless
        # - AYON_SERVER_URL
        # - AYON_API_KEY
        #   - https://help.ayon.app/en/help/articles/6698141-user-management#klrl452c446
        # Base Packages
        zlib
        zstd
        glib
        libGL
        fontconfig
        libx11
        libxkbcommon
        freetype
        dbus

        # Tray Packages
        libxcb
        libxcb-image
        libxcb-render-util
        libxcb-cursor
        libxcb-keysyms
        libxcb-wm

        which
      ];

      # Ayon 1.6.3
      version = "1.6.3";
      version-dashed = builtins.replaceStrings ["."] ["-"] version;
      path = "/data/share/tools/AYON-${version}-linux-rocky9";

      profile = ''
        export PATH=${path}:$PATH

        export AYON_LAUNCHER_STORAGE_DIR="/data/share/tools/AYON-deps"
        # Had no effect here:
        # export AYON_MENU_LABEL="OpenStudioLandscapes-Ayon"

        # TEMP
        # - [x] tested
        # - [x] is effective by itself
        # - affects Ayon
        # However:
        # - Saved session recovery to "/tmp/quit.blend"
        export TEMP="$XDG_DATA_HOME/OpenStudioLandscapes/OpenStudioLandscapes-Ayon/logs.temp"
        mkdir -p $TEMP

        # TMP
        # - [x] tested
        # - [x] is effective by itself
        # - affects Ayon and Blender
        export TMP="$XDG_DATA_HOME/OpenStudioLandscapes/OpenStudioLandscapes-Ayon/logs.tmp"
        mkdir -p $TMP

        # don't remember what this was for:
        # (does not seem to have an effect on the env anyway)
        # an alternative could be to use lib.makeLibraryPath
        # - https://noogle.dev/f/lib/makeLibraryPath/
        export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
          pkgs.wayland
        ]}:$LD_LIBRARY_PATH

        export AYON_SERVER_URL=https://ayon.openstudiolandscapes.meemoo.ch
        # export AYON_API_USER=ayon_tray
        # export AYON_API_KEY=<API_KEY>
        #
        # Setting XTERM seems to be needed when launching ayon from an IDE terminal
        # https://runebook.dev/en/docs/python/library/curses/curses.setupterm
        # Values for TERM:
        # - xterm
        # - screen
        # - linux
        # - xterm-256color
        export TERM=linux
        # Not sure yet if TERMINFO is needed as well
        # export TERMINFO=/etc/terminfo

        export DEFAULT_ARGS="${builtins.toString ayon-default-args}"
      '';

      fhs-ayon = pkgs.buildFHSEnv {
        name = "ayon-${version-dashed}-package";
        # /data/share/tools/ayon-4.4.3-linux-x64/ayon
        # bash: /data/share/tools/ayon-4.4.3-linux-x64/ayon: Permission denied
        inherit profile;

        runScript = pkgs.lib.getExe runScript-ayon-launcher;

        # it seems like nix is `exec`ing:
        # runScript = "(${pkgs.lib.getExe runScript-4-4-3})";
        # Results in:
        # /nix/store/22hh7ylmf62r31vzas0ir8da9kprcll8-fhs-ayon-init: line 3: syntax error near unexpected token `/nix/store/r8mmqvnjj3ln69slmz1p2c6azkclwr41-ayon-4-4-3-bin/bin/ayon-4-4-3-bin'
        # /nix/store/22hh7ylmf62r31vzas0ir8da9kprcll8-fhs-ayon-init: line 3: `exec (/nix/store/r8mmqvnjj3ln69slmz1p2c6azkclwr41-ayon-4-4-3-bin/bin/ayon-4-4-3-bin) "$@"'
        # nix run /home/michael/git/repos/my-test-flake-01#ayon-4-4-3

        # tarkgetPkgs expects a function
        targetPkgs = pkgs: (pkgs-base);
      };

      pkgs-dev-ayon = (with pkgs; [
        # fhs shell
        (pkgs.buildFHSEnv {
          name = "fhs";
          runScript = "bash";
          targetPkgs = pkgs: (pkgs-base);
        })
      ]);

      # # This is the launch script for Blender 4.4.3
      # maybe we could use `/run/current-system/sw/bin/xdg-terminal "command"`
      #    4847    3082 Ss    |   |   \_ bash
      #   13139    4847 S+    |   |   |   \_ bwrap
      #   13218   13139 S+    |   |   |       \_ init
      #   13221   13218 S+    |   |   |           \_ sleep

      # $ pidof bwrap
      # 15717

      # $ ps -e -o pid,ppid,stat,comm --forest

      # $ ps -p $(pidof bwrap) -o args | cat
      # /nix/store/f2bsh1n6snqdldnjdshdy1lw3hnlfxwi-bubblewrap-0.12.0/bin/bwrap --dev-bind /dev /dev --proc /proc --chdir /home/michael/git/repos/flake-ayon --die-with-parent --bind /nix /nix --tmpfs /nix/store/dphsh3jff8w6n9p3xbfmkia5krqwv52f-glibc-2.42-103/etc --tmpfs /etc --symlink /etc/ld.so.conf /nix/store/dphsh3jff8w6n9p3xbfmkia5krqwv52f-glibc-2.42-103/etc/ld.so.conf --symlink /etc/ld.so.cache /nix/store/dphsh3jff8w6n9p3xbfmkia5krqwv52f-glibc-2.42-103/etc/ld.so.cache --ro-bind /nix/store/dphsh3jff8w6n9p3xbfmkia5krqwv52f-glibc-2.42-103/etc/rpc /nix/store/dphsh3jff8w6n9p3xbfmkia5krqwv52f-glibc-2.42-103/etc/rpc --remount-ro /nix/store/dphsh3jff8w6n9p3xbfmkia5krqwv52f-glibc-2.42-103/etc --symlink /nix/store/j8bhmgnvyzah3nzhr2bdwz7xar12gqgl-ayon-1-6-3-package-init /init --ro-bind /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/nix-support /nix-support --ro-bind /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/usr /usr --ro-bind /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/dbus-1 /etc/dbus-1 --ro-bind /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/pam.d /etc/pam.d --ro-bind /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/profile.d /etc/profile.d --ro-bind /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/systemd /etc/systemd --ro-bind /etc /.host-etc --symlink /usr/bin /bin --symlink /usr/lib /lib --symlink /usr/lib32 /lib32 --symlink /usr/lib64 /lib64 --symlink /usr/libexec /libexec --symlink /usr/sbin /sbin --symlink /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/login.defs /etc/login.defs --symlink /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/mtab /etc/mtab --symlink /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/profile /etc/profile --symlink /nix/store/25dqpx40vx07gfgysrdd21138vg5r85i-ayon-1-6-3-package-fhsenv-rootfs/etc/rpc /etc/rpc --symlink /.host-etc/static /etc/static --symlink /.host-etc/nix /etc/nix --symlink /.host-etc/shells /etc/shells --symlink /.host-etc/bashrc /etc/bashrc --symlink /.host-etc/passwd /etc/passwd --symlink /.host-etc/group /etc/group --symlink /.host-etc/shadow /etc/shadow --symlink /.host-etc/hosts /etc/hosts --symlink /.host-etc/resolv.conf /etc/resolv.conf --symlink /.host-etc/nsswitch.conf /etc/nsswitch.conf --symlink /.host-etc/profiles /etc/profiles --symlink /.host-etc/sudoers /etc/sudoers --symlink /.host-etc/localtime /etc/localtime --symlink /.host-etc/zoneinfo /etc/zoneinfo --symlink /.host-etc/machine-id /etc/machine-id --symlink /.host-etc/os-release /etc/os-release --symlink /.host-etc/fonts /etc/fonts --symlink /.host-etc/alsa /etc/alsa --symlink /.host-etc/ssl/certs /etc/ssl/certs --symlink /.host-etc/pki /etc/pki --symlink /.host-etc/dconf /etc/dconf --bind /boot /boot --bind /data /data --bind /home /home --bind /lost+found /lost+found --bind /media /media --bind /mounts /mounts --bind /opt /opt --bind /root /root --bind /run /run --bind /srv /srv --bind /sys /sys --bind /tmp /tmp --bind /var /var --tmpfs /tmp/.X11-unix --ro-bind-try /tmp/.X11-unix/X0 /tmp/.X11-unix/X0 /nix/store/cc7xc42knz0xi5i13i4agap64labrxjl-container-init
      # So, `bwrap` does `--bind /data /data` which will list `/data` as a mount point
      # in the container but that does not reflect the mount status of `/data` on
      # the host.
      # We can now use `--task <tid>` to query for `/data` on the host directly:
      # `findmnt --task 1 /data`, which will search `/proc/1/mountinfo` instead
      # of `/proc/$$/mountinfo` (`$$` refers to self `pid`).
      runScript-ayon-launcher = pkgs.writeScriptBin "ayon-${version-dashed}-bin" ''
        echo "Process ID:" $$

        echo "AYON_LAUNCHER_STORAGE_DIR is:" $AYON_LAUNCHER_STORAGE_DIR

        # We can't use `readlink /data` in the container
        # echo "/data points to: $(readlink /data)"

        ${pkgs.util-linux}/bin/findmnt --task 1 /mounts/data/sshfs > /dev/null

        # $? represents the last return code
        if [ $? -gt 0 ]; then
          echo -e "\nIs /data mounted?\n"
          echo "Exitting."
          exit 1
        fi

        echo "Running ${pkgs.lib.getBin (pkgs.glibc)}/bin/ldd $(which ayon)..." \
          && ${pkgs.lib.getBin (pkgs.glibc)}/bin/ldd $(which ayon) | sort --ignore-leading-blanks --ignore-case | grep -E --color "\b(not found)\b|$" \
          && echo "Launching $(which ayon)" \
          && echo "- with default args \"${builtins.toString ayon-default-args}\"" \
          && echo "- with extra args \"$@\"" \
          && echo "..." \
          && ayon ${builtins.toString ayon-default-args} $@
      '';

    ayon-default-args = [
      "--debug"
    ];

  in

  {
    # https://determinate.systems/blog/nix-run/
    # A simple executable package
    packages = {
      "ayon-${version-dashed}-package" = fhs-ayon;
    };

    # https://discourse.nixos.org/t/flakes-way-of-creating-a-fhs-environment/20821
    # https://nixos.wiki/wiki/Flakes#nix_run
    # https://nix.dev/manual/nix/2.34/command-ref/new-cli/nix3-run.html#apps
    # https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix/#apps}
    apps = {
      "ayon-${version-dashed}-app" = {
        type = "app";
        program = self.packages.x86_64-linux."ayon-${version-dashed}-package";
        meta.description = "Launch ayon ${version}";
      };
    };

    # https://hugosum.com/blog/recreating-development-environment-with-nix-flake
    devshells = rec {
      # default = "ayon-${version-dashed}-devshell";
      "ayon-${version-dashed}-devshell" = {
        packages = pkgs-dev-ayon;
        name = "ayon-${version-dashed}-devshell";
        motd = ''
          You are now in a ayon ${version} configured environment.
          Call "fhs" to setup File Hierarchy Standard.

          DEFAULT_ARGS = "$DEFAULT_ARGS"

          Available commands:
          $(find ${path} -maxdepth 1 -type f -executable | sort)
        '';
        devshell.startup.fhs.text = ''
          # `inherit profile;` does not work for devshells.
          # so seems to be the only option to get the
          # same env in the devshell
          ${profile}

          # aliases are not exported to subshells
          # hence, use functions
          #
          # automatically export all functions declared here:
          # set -a

          ayon-help() {
            set -x;
            command ayon $DEFAULT_ARGS --help;
            set +x;
          }

          ayon-interactive() {
            set -x;
            command ayon $DEFAULT_ARGS interactive;
            set +x;
          }

          # set +a
        '';
        # Custom Env:
#        env = [
#          {
#            name = "AYON_LAUNCHER_STORAGE_DIR";
#            value = "/data/share/tools/AYON-deps";
#          }
#          # {
#          #   name = "PATH";
#          #   prefix = path;
#          # }
#          # {
#          #   name = "DEFAULT_ARGS";
#          #   value = "${builtins.toString blender-default-args}";
#          # }
#        ];
      };
    };
  };
}
