{ pkgs ? import <nixpkgs> {} }:
pkgs.buildGoModule {
  pname = "ssh-to-pgp";
  version = "0.0.1";

  src = ./.;

  vendorSha256 = "sha256-ZF/WsmqmGHZIAGTPKJ70UhtmssNhiInEZfzrKxQLw9I=";

  checkInputs = [ pkgs.gnupg ];
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
