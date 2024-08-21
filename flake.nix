# SPDX-FileCopyrightText: Olivier Le Doeuff <olivier.ldff@gmail.com>
# SPDX-License-Identifier: MIT
{
  description = "qaterial-hot-reload";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nix-gl-host = {
      url = "github:numtide/nix-gl-host";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qolm = {
      url = "github:olivierldff/qolm/v3.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-filter.follows = "nix-filter";
    };
    qaterial = {
      url = "github:olivierldff/qaterial/v1.5.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-filter.follows = "nix-filter";
      inputs.qolm.follows = "qolm";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , nix-filter
    , nix-gl-host
    , qaterial
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (_: _: {
            inherit (qaterial.packages.${system}) qaterial;
          })
        ];
      };

      qt = pkgs.qt6;
      nixglhost = nix-gl-host.packages.${system}.default;

      nativeBuildInputs = with pkgs; [
        qt.wrapQtAppsHook
        makeWrapper
        gcc
        git
        cmake
        cpm-cmake
        ninja
        gtest
      ];

      buildInputs = [
        pkgs.qaterial
      ] ++ (with pkgs.qt6; [
        qtbase
        qtsvg
        qtdeclarative
        qt5compat
        qtmultimedia
        qt3d
        qtgraphs
        qtquick3d
        qtshadertools
      ]);

      nativeCheckInputs = with pkgs; [
        dbus
        xvfb-run
      ];

      shellHook = ''
        # Crazy shell hook to set up Qt environment, from:
        # https://discourse.nixos.org/t/python-qt-woes/11808/12
        setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
        echo "shellHook: setQtEnvironment = $setQtEnvironment"
        makeWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
        sed "/^exec/d" -i "$setQtEnvironment"
        source "$setQtEnvironment"
      '';

      devShellHook = pkgs.lib.concatStringsSep "\n" (
        [ shellHook ]
      );

      CPM_USE_LOCAL_PACKAGES = "ON";

      packages = {
        default = null;
        deadnix = pkgs.runCommand "deadnix" { } ''
          ${pkgs.deadnix}/bin/deadnix --fail ${./.}
          mkdir $out
        '';
      };

      apps = {
        default = null;
      };

      minimalDevBuildInputs = with pkgs; [
        gh
      ];
      fullDevBuildInputs = with pkgs; nativeBuildInputs
        ++ nativeCheckInputs
        ++ minimalDevBuildInputs
        ++ [
        sccache
        nixpkgs-fmt
        cmake-format
        clang-tools
        lazygit
        neovim
        nixglhost
      ]
        ++ (with pkgs.qt6; [ qtlanguageserver ])
        ++ pkgs.lib.lists.optionals (stdenv.isLinux) [
        gdb
      ];

    in
    {
      inherit packages apps;

      devShells = {
        minimal = pkgs.mkShell {
          name = "qaterial-hot-reload-minimal-shell";

          inherit buildInputs shellHook;
          inherit CPM_USE_LOCAL_PACKAGES;

          nativeBuildInputs = nativeBuildInputs
            ++ nativeCheckInputs
            ++ minimalDevBuildInputs;
        };

        default = pkgs.mkShell {
          name = "qaterial-hot-reload-dev-shell";

          inherit buildInputs;
          inherit CPM_USE_LOCAL_PACKAGES;

          shellHook = devShellHook;
          nativeBuildInputs = fullDevBuildInputs;
        };
      };

      formatter = pkgs.nixpkgs-fmt;
      checks = {
        inherit (self.packages.${system}) deadnix;
      };
    });
}
