{ pkgs ? import <nixpkgs> {} }:
pkgs.buildGoModule {
  pname = "ssh-to-pgp";
  version = "1.0.4";

  src = ./.;

  vendorSha256 = "sha256-J9HuZhjeXSS4ej1RM+yn2VGoSdiS39PDM4fScAh6Eps=";

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
