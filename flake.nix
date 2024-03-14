{
  description = "Development environment for this project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      imports = [ ./treefmt.nix ];
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
        checks.lint = pkgs.callPackage ./lint.nix {
          inherit (config.packages) ssh-to-pgp;
        };
      };
    });
}
