with import <nixpkgs> { };

buildEnv {
  name = "nix-env-nix-user";

  paths = [
    bzip2
    direnv
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
