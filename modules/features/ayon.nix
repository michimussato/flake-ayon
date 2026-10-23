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
        # - xtern
        # - screen
        # - linux
        # - xterm-256color
        export TERM=linux
        # Not sure yet if TERMINFO is needed as well
        # export TERMINFO=/etc/terminfo

        # export DEFAULT_ARGS="${builtins.toString ayon-default-args}"
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
      runScript-ayon-launcher = pkgs.writeScriptBin "ayon-${version-dashed}-bin" ''
        echo "Running ${pkgs.lib.getBin (pkgs.glibc)}/bin/ldd $(which ayon)..." \
          && ${pkgs.lib.getBin (pkgs.glibc)}/bin/ldd $(which ayon) | sort --ignore-leading-blanks --ignore-case | grep -E --color "\b(not found)\b|$" \
          && echo "Launching $(which ayon)" \
          && echo "- with default args \"${builtins.toString ayon-default-args}\"" \
          && echo "- with extra args \"$@\"" \
          && echo "..." \
          && ayon ${builtins.toString ayon-default-args} $@
      '';

    ayon-default-args = [
      # "--python-use-system-env"
      # "--enable-autoexec"
      # "--verbose" # expects a verbosity level
      # "4"  # fatal, error, warning, info, debug, and trace
      # "--debug"
      # "--debug-cycles"
      # "--debug-ffmpeg"
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

          # set +a
        '';
        # Custom Env:
        # env = [
        #   {
        #     name = "DEV_SHELL";
        #     value = "blender-4-4-3";
        #   }
        #   # {
        #   #   name = "PATH";
        #   #   prefix = path;
        #   # }
        #   # {
        #   #   name = "DEFAULT_ARGS";
        #   #   value = "${builtins.toString blender-default-args}";
        #   # }
        # ];
      };
    };
  };
}
