{ pkgs, stdenv, runCommand, makeWrapper, fetchgit, nodejs }:
let
  source = fetchgit {
    url = "https://github.com/RobinLinus/snapdrop.git";
    sha256 = "sha256-oMO6X6ICh3urSFpgpgS4x5olM+RHGqPyyiC0hHnDJuY=";
  };
  server = (import ./server.nix { inherit pkgs source; }).package;
in runCommand "snapdrop" { nativeBuildInputs = [ makeWrapper ]; } ''
  mkdir -p $out/bin
  makeWrapper ${nodejs}/bin/node $out/bin/snapdrop --add-flags ${server}/lib/node_modules/snapdrop/index.js
  mkdir -p $out/lib/share/snapdrop
  cp -R ${source}/client $out/lib/share/snapdrop/client
''
