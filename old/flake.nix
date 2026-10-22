{
  description = "Flake Ayon";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };
  };

  # outputs = { self, nixpkgs }:

#  outputs = inputs: {
#    packages = builtins.mapAttrs (system: pkgs: {
#      hello = pkgs.hello;
#
#      default = inputs.self.packages.${system}.hello;
#    }) inputs.nixpkgs.legacyPackages;
#  };

  outputs = { self, nixpkgs }:

  let
    # https://discourse.nixos.org/t/allow-insecure-packages-in-flake-nix/34655/8
    pkgs = import nixpkgs {
      system = "x86_64-linux";
#        inherit system;
#      config = {
#        permittedInsecurePackages = [
#          "openexr-2.5.10"
#          "ilmbase-2.5.10"
#        ];
#      };
    };
    # pkgs = nixpkgs.legacyPackages.x86_64-linux;
    pname = "ayon";
    version = "1.6.3";
  in

  rec {
    packages.x86_64-linux.default = packages.x86_64-linux."${pname}-${version}";

    packages.x86_64-linux."${pname}-${version}" = pkgs.stdenv.mkDerivation {
      # package name
      inherit pname;
      # package version
      inherit version;

      # https://noogle.dev/f/builtins/fetchGit/
      src = builtins.fetchGit {
        url = "https://github.com/ynput/ayon-launcher.git";
        # Tag 1.6.3
        rev = "972df7c9edf4739c33ca98675da198098377ac57";
        submodules = true;
        shallow = true;
      };

       # Build time dependencies
      nativeBuildInputs = with pkgs; [
        bash
        curl
        git
        rustup
        uv
        python313
        cmake
        #glibc
        #glib

        libz
        zlib
        readline
        sqlite
        wget
        llvm
        ncurses5
        xz
        tk
        libxml2
        xmlsec

        tree
        which
        pkg-config
        # [...]
        # fatal: unable to access 'https://github.com/madler/zlib.git/': SSL certificate OpenSSL verify result: unable to get local issuer certificate (20)
        # [...]
        # https://github.com/NixOS/nixpkgs/issues/409848
        # echo "NIX_SSL_CERT_FILE: $NIX_SSL_CERT_FILE"
#        cacert
        # Disable sandbox so that extra repos can be cloned (requires git)
#        git

#        perl
      ];

      build-system = [ pkgs.bash ];

      dontUnpack = true;
      dontConfigure = true;
      dontPatch = true;
      dontPatchELF = true;


#      # > error: Failed to initialize cache at `/homeless-shelter/.cache/uv`
#      # >   Caused by: failed to create directory `/homeless-shelter/.cache/uv`: Permission denied (os error 13)
#      # -> https://stackoverflow.com/a/78185023/2207196
#      preBuild = ''
#        # export HOME=$(mktemp -d)
#        export HOME=$TEMP
#        # export UV_CACHE_DIR=$TEMP
#      '';
#
#      dontBuild = false;
#      buildPhase = ''
#        runHook preBuild
#        #mkdir -p $out
#        # env
#        #which patchelf
#        env
#        sh $src/tools/make.sh createenv
#        sh $src/tools/make.sh build
#      '';

#      installPhase = ''
#        mkdir -p $out
#        sh $src/tools/make.sh help
#      '';



      buildCommand = ''
        echo "src = $src"
        echo "out = $out"
        #env

        mkdir -p $out
        cd $out


        export UV_CACHE_DIR=$TEMP
        export UV_INSTALL_DIR=$TEMP

        uv python install 3.11.9 --default
        which python
        python -m venv $out/.venv
        source $out/.venv/bin/activate
        pip install $src

        # which uv
        # export UV_CACHE_DIR=$TEMP
        # export UV_WORKING_DIR=$src

        # uv help
        # uv sync --active



        export HOME=$(mktemp -d)
        # HOME=$out
        uv sync

        # ls -alh $src

        # echo "tree src = "
        # tree $src

        # sh $src/etc/Linux/sbuild.sh $src Release
        # uv help
        # uv help venv
        # pushd $NIX_BUILD_TOP
        # pushd /build
        # uv venv --project $src --directory /build --allow-existing && uv sync --all-extras
        # uv run --project $src --directory /build pre-commit install
        # popd
        # exit 1
        sh $src/tools/make.sh create-env
        # sh $src/tools/make.sh install-runtime-dependencies

        mkdir -p $out
        # cp -a $NIX_BUILD_TOP/install-Release/. $out
      '';

    };
  };

}
