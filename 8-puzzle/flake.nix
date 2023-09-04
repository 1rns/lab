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

    perSystem = { pkgs, system, ... }: {
      devShells.default = pkgs.mkShell {
        name = "C++ shell environment";

        shellHook = "echo 'Entering a C++ shell environment...'";

        packages = with pkgs; [
          boost
          gcc
          cmake
          ccls
        ];

      };
    };
  };
}
