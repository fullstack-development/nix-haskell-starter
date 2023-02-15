{ imageTag ? null }:

with import ./nix/nixpkgs.nix;
let
  CONFIG_FILEPATH = builtins.getEnv "CONFIG_FILEPATH";
  dockerTools = pkgs.dockerTools;
  sourceImage = dockerTools.pullImage {
        imageName = "centos";
        imageDigest = "sha256:e4ca2ed0202e76be184e75fb26d14bf974193579039d5573fb2348664deef76e";
        sha256 = "sha256-hDClXCqmBeo1vsD7hmumryZfvsPwxzWj6zG0udhvPm8=";
        finalImageTag = "7";
        finalImageName = "centos";
      };

  makeDockerImage = name: revision: packages: entryPoint:
    dockerTools.buildImage {
      name = name;
      tag = revision;
      fromImage = sourceImage;
      contents = (with pkgs; [ bashInteractive coreutils htop strace ]) ++ packages;
      config.Cmd = entryPoint;
      config.Workdir = "/bin";
    };

  project-exes = our-project-exes;
  nixHaskellStarterImage = makeDockerImage "NixHaskellStarter" 
    (if imageTag == null then "undefined" else imageTag)
    [ project-exes ]
    [ "/bin/sh" "-c"  "/bin/hello"];

in { inherit nixHaskellStarterImage; }
