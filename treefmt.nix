{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        # Used to find the project root
        projectRootFile = "flake.lock";
        flakeCheck = pkgs.hostPlatform.system != "riscv64-linux";

        programs = {
          deno.enable = true;
          gofumpt.enable = true;
          deadnix.enable = true;
          nixfmt-rfc-style.enable = true;
        };
      };
    };
}
