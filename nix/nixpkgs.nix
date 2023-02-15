
let
  sources = import ./sources.nix {};

  nixpkgsSrc = sources.nixpkgs ;
  
  overlay = self: super: {
    our-haskell-pkg-set = self.haskell.packages.ghc922.override {
      overrides = hself: hsuper: {
        
        nix-haskell-starter = hself.callCabal2nix "nix-haskell-starter" ../. {};
        servant-server = hsuper.servant-server.overrideAttrs (_: { patches = [ ]; });
        ormolu = hsuper.ormolu.overrideAttrs (old: {src = sources.ormolu;});
        our-local-pkgs = [
          hself.nix-haskell-starter
        ];
      };
    };

    our-shell = self.our-haskell-pkg-set.shellFor {
      packages = pkgs: pkgs.our-local-pkgs;
      buildInputs = [
        self.cabal-install
        self.haskell-language-server
        self.haskellPackages.ghcid
        self.hlint
        self.our-haskell-pkg-set.ormolu
      ];
    };

    our-project-exes = self.buildEnv {
      name = "nix-haskell-starter-project";
      paths = self.our-haskell-pkg-set.our-local-pkgs;
      extraOutputsToInstall = [ "dev" "out" ];
    };
  };

in

import nixpkgsSrc {
  overlays = [ overlay ];
}
