{
  description = "Development environment for C++";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.parts.lib.mkFlake { inherit inputs; } {
      # Supported systems.
      systems = [
        "x86_64-linux" # intel/amd linux
        "aarch64-linux" # arm linux
        "x86_64-darwin" # intel mac
        "aarch64-darwin" # arm mac
      ];

    perSystem = { lib, pkgs, system, ... }: {
      devShells.default = pkgs.mkShell rec {
        name = "C++ shell environment";

        shellHook = ''
          echo 'Entering: ${name}...'
          echo 
          echo Packages: ${builtins.concatStringsSep ", " (lib.forEach packages lib.getName)}
        '';

        packages = with pkgs; [
          gcc
          SDL2
          cmake
          ccls
        ];
      };

      packages = {
        sdl-bgi = pkgs.callPackage ./sdl-bgi {}; 
      };
      
    };
  };
}
