{
  description = "Demo of Kotlin compile failure with pkgs.gradle with toolchain override";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { flake-parts, devshell , ... }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { config, self', inputs', pkgs, system, lib, ... }: let
        inherit (pkgs) stdenv;
      in {
        # define default devshell
        devShells.default = pkgs.mkShell {
          packages = with pkgs ; [
                (gradle.override {
                    java =  jdk23 ; # Run Gradle with  JDK 23
                })
            ];
        };
      };
    };
}
