{
  description = "Development environment for this project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ lib, ... }: {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "riscv64-linux"

        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = { config, pkgs, ... }: {
        packages.ssh-to-pgp = pkgs.callPackage ./default.nix { };
        packages.default = config.packages.ssh-to-pgp;

        checks.ssh-to-pgp = config.packages.ssh-to-pgp;
      };
    });
}
