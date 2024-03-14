{ ssh-to-pgp, golangci-lint }:
ssh-to-pgp.overrideAttrs (old: {
  name = "golangci-lint";
  nativeBuildInputs = old.nativeBuildInputs ++ [ golangci-lint ];
  buildPhase = ''
    HOME=$TMPDIR golangci-lint run --timeout 360s
  '';
  doCheck = false;
  installPhase = ''
    touch $out $unittest
  '';
  fixupPhase = ":";
})
