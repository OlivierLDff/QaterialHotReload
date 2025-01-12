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
      url = "github:olivierldff/qolm/v3.2.3";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-filter.follows = "nix-filter";
    };
    qaterial = {
      url = "github:olivierldff/qaterial/v1.5.2";
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
      nixglhost = if pkgs.stdenv.isLinux then nix-gl-host.packages.${system}.default else null;

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
      version = import ./nix/get-project-version.nix { file = ./cmake/Version.cmake; prefix = "QATERIALHOTRELOAD"; };

      outFolder = if pkgs.stdenv.isLinux then "bin" else if pkgs.stdenv.isDarwin then "Applications" else throw "Unsupported system: ${pkgs.stdenv.system}";
      outApp = if pkgs.stdenv.isLinux then "QaterialHotReloadApp" else if pkgs.stdenv.isDarwin then "QaterialHotReloadApp.app" else throw "Unsupported system: ${pkgs.stdenv.system}";
      outAppExe = if pkgs.stdenv.isLinux then outApp else if pkgs.stdenv.isDarwin then "${outApp}/Contents/MacOS/QaterialHotReloadApp" else throw "Unsupported system: ${pkgs.stdenv.system}";

      qaterialHotReloadApp = pkgs.stdenv.mkDerivation rec {
        inherit version nativeBuildInputs buildInputs;
        inherit CPM_USE_LOCAL_PACKAGES;
        propagatedBuildInputs = buildInputs;

        pname = "qaterialhotreloadapp";
        src = nix-filter {
          root = ./.;
          include = [
            "cmake"
            "src"
            "platforms"
            "qml"
            ./CMakeLists.txt
          ];
        };

        cmakeFlags = [
          (pkgs.lib.strings.cmakeBool "QATERIALHOTRELOAD_ENABLE_APPIMAGE" false)
          (pkgs.lib.strings.cmakeBool "QATERIALHOTRELOAD_ENABLE_DMG" false)
          (pkgs.lib.strings.cmakeBool "QATERIALHOTRELOAD_USE_LOCAL_CPM_FILE" true)
          "-GNinja"
        ];

        cmakeConfigType = "Release";
        enableParallelBuilding = true;
        # Enable debug output folder to exists and be kept
        separateDebugInfo = true;

        out = [ "out" ];

        buildPhase = ''
          runHook preBuild

          echo "Building qaterialhotreloadapp version ${version} in ${cmakeConfigType} mode"

          cmake --build . --config ${cmakeConfigType} --target \
            QaterialHotReloadApp \
            --parallel $NIX_BUILD_CORES

          runHook postBuild
        '';

        doCheck = pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform;

        installPhase = ''
          runHook preInstall

          echo "Installing qaterialhotreloadapp version ${version} in ${cmakeConfigType} mode into $out"
          mkdir -p $out/${outFolder}
          cp -r ${outApp} $out/${outFolder}
          ${pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
            mkdir -p $out/bin
            ln -s $out/${outFolder}/${outAppExe} $out/bin/qaterialhotreloadapp
          ''}

          runHook postInstall
        '';

        doInstallCheck = doCheck;
        installCheckPhase = pkgs.lib.optionalString doInstallCheck ''
          runHook preInstallCheck

          echo "Run shell hook"
          ${shellHook}

          export QT_QPA_PLATFORM=offscreen
          $out/${outFolder}/${outAppExe} --help

          runHook postInstallCheck
        '';
      };

      qaterialHotReloadAppGlHost =
        if pkgs.stdenv.isLinux then
          (pkgs.stdenv.mkDerivation {
            pname = "qaterialHotReloadAppGlHost";
            inherit version;

            dontUnpack = true;

            installPhase = ''
              mkdir -p $out/bin
              cat > $out/bin/qaterialHotReloadAppGlHost <<EOF
              #!${pkgs.bash}/bin/bash
              exec ${nixglhost}/bin/nixglhost ${packages.qaterialHotReloadApp}/bin/QaterialHotReloadApp -- \$@
              EOF
              chmod +x $out/bin/qaterialHotReloadAppGlHost
            '';
          }) else null;

      packages = {
        inherit qaterialHotReloadApp;
        default = qaterialHotReloadApp;
        deadnix = pkgs.runCommand "deadnix" { } ''
          ${pkgs.deadnix}/bin/deadnix --fail ${./.}
          mkdir $out
        '';
      } // (
        if pkgs.stdenv.isLinux then { inherit qaterialHotReloadAppGlHost; } else { }
      );

      apps = {
        qaterialHotReloadApp = flake-utils.lib.mkApp {
          drv = packages.qaterialHotReloadApp;
        };
        default = apps.qaterialHotReloadApp;
      } // (
        if pkgs.stdenv.isLinux then {
          qaterialHotReloadAppGlHost = flake-utils.lib.mkApp {
            drv = packages.qaterialHotReloadAppGlHost;
          };
        } else { }
      );

      minimalDevBuildInputs = with pkgs; [
        gh
      ];
      fullDevBuildInputs = with pkgs; nativeBuildInputs
        ++ minimalDevBuildInputs
        ++ [
        sccache
        nixpkgs-fmt
        cmake-format
        clang-tools
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
