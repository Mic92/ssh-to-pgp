# ssh-to-pgp
Convert SSH RSA keys to GPG keys

## Usage
-  Exports the private:

```console
$ ssh-to-pgp -private-key -i $HOME/.ssh/id_rsa -o private-key.asc
2504791468b153b8a3963cc97ba53d1919c5dfd4
```

- Exports the public key:

```console
$ ssh-to-pgp -i $HOME/.ssh/id_rsa -o public-key.asc
2504791468b153b8a3963cc97ba53d1919c5dfd4
```

## Install with nix

```nix
$ nix run -f https://github.com/Mic92/sops-to-nix/archive/master.tar.gz ssh-to-pgp
```

## Install with go

``` nix
$ go get github.com/Mic92/ssh-to-pgp
```
