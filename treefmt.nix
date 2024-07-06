{ lib, inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        # Used to find the project root
        projectRootFile = "flake.lock";

        programs = lib.mkIf (pkgs.hostPlatform.system != "riscv64-linux") {
          deno.enable = true;
          gofumpt.enable = true;
          deadnix.enable = true;
          nixfmt-rfc-style.enable = true;
        };
      };
    };
}
