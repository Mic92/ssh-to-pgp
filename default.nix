{ pkgs ? import <nixpkgs> {} }:
pkgs.buildGoModule {
  pname = "ssh-to-pgp";
  version = "1.0.2";

  src = ./.;

  vendorSha256 = "sha256-3N3D0OSGai3czkfUB6rTMeGqfoZD5ZYg1lqRC24OeqA=";

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
