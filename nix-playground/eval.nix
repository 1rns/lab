{ pkgs, ... }:
pkgs.lib.evalModules {
  modules = [
    ./default.nix
    ({ config, ... }: { config._module.args = { inherit pkgs; }; })
  ];
}
