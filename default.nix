{ pkgs ? import <nixpkgs> {}, vendorHash ? "sha256-a0E554bwHG8ixIXWm5Vf+vBFCLRuV2G0rl2blxYAixg=" }:
pkgs.buildGoModule {
  pname = "ssh-to-pgp";
  version = "1.0.4";

  src = ./.;

  inherit vendorHash;

  checkInputs = [ pkgs.gnupg ]; # no longer needed when we get rid of nixpkgs 22.11
  nativeCheckInputs = [ pkgs.gnupg ];
  checkPhase = ''
    HOME=$TMPDIR go test .
  '';

  shellHook = ''
    unset GOFLAGS
  '';

  doCheck = true;

  meta = with pkgs.lib; {
    description = "Convert ssh private keys to PGP";
    homepage = "https://github.com/Mic92/sops-nix";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
