with import <nixpkgs> { };

buildEnv {
  name = "nix-env-nix-user";

  paths = [
    bzip2
    file
    gnutar
    gzip
    less
    man
    procps
    tree
    wget
  ];
}
