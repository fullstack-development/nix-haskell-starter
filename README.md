# nix-haskell-starter

Simple nix config to start haskell project

- Clone or fork that project
- Find `nix-haskell-starter`, `NixHaskellStarter`, `nixHaskellStarter` and rename to your project name.

# Install & run

1) Run `nix-shell` from project root directory
2) Run `cabal build` under the nix shell
3) Run `hello`

# Create docker image

1) Build image from `docker.nix` (could be run without nix shell environment): 
   `nix-build --argstr imageTag latest docker.nix`
2) Load image to docker images: `docker load < result`
3) Check docker images: `docker images`
