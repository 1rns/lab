{
  inputs.nixpkgs.url = "https://github.com/NixOS/nixpkgs/tarball/nixos-22.11";

  outputs = { nixpkgs, ... }:
    let
      pkgs = import nixpkgs { config = { }; overlays = [ ]; system = "x86_64-linux"; };
    in
    {
      packages.x86_64-linux.default = (import ./eval.nix { inherit pkgs; }).config.scripts.output;
    };
}
