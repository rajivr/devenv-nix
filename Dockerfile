FROM debian:sid-slim

COPY [ \
  "./docker-extras/*", \
  "/tmp/docker-build/" \
]

RUN \
  apt-get update -m && \
  \
  # install nix dependencies
  apt-get install -y \
    curl \
    vim \
    sudo \
    xz-utils && \
  \
  # setup nix-user account and sudo
  groupadd -g 1000 nix-user && \
  useradd -d /home/nix-user -g nix-user -m -N -u 1000 nix-user && \
  echo "nix-user    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  \
  # disable nix sandbox (otherwise installation will fail inside docker build)
  su -l nix-user -c "mkdir -p /home/nix-user/.config/nix" && \
  su -l nix-user -c "echo 'sandbox = false' > /home/nix-user/.config/nix/nix.conf" && \
  \
  su -l nix-user -c "mkdir /tmp/nix-install" && \
  su -l nix-user -c "cd /tmp/nix-install; curl -LO https://nixos.org/releases/nix/latest/install; chmod 755 install; ./install" && \
  \
  su -l nix-user -c "nix-env -f /tmp/docker-build/nix-env-nix-user.nix --install" && \
  \
  su -l nix-user -c "rm -rf /tmp/nix-install" && \
  \
  su -l nix-user -c "nix-store --gc" && \
  \
  # setup bash aliases (do this at the end to avoid file missing warnings)
  su -l nix-user -c "cat /tmp/docker-build/home-nix-user-.profile-append >> ~/.profile"

RUN \
  # cleanup
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/tmp/* && \
  rm -rf /tmp/*
