{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            neovim
            R
            rPackages.languageserver # <-- critical for r_language_server
            rPackages.jsonlite # optional but common
            rPackages.rmarkdown # if you do Rmd/Quarto-ish work
            rPackages.pagedown
            rPackages.tidyverse
            rPackages.dplyr
            rPackages.nycflights13
            rPackages.ggplot2
            rPackages.openintro
            rPackages.nnet
            texliveFull
            rPackages.plotly
            chromium
            pandoc
          ];

          shellHook = ''
            export R_LIBS_USER="$PWD/.R/library"
            mkdir -p "$R_LIBS_USER"
          '';
        };
      }
    );
}
