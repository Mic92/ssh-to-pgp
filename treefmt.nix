{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        # Used to find the project root
        projectRootFile = "flake.lock";
        flakeCheck = pkgs.stdenv.hostPlatform.system != "riscv64-linux";

        programs = {
          mdformat.enable = true;
          yamlfmt.enable = true;
          gofumpt.enable = true;
          deadnix.enable = true;
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt;
          };
        };
      };
    };
}
