{
  description =
    "A set of programs packaged by Ninlives. Currently only tested on x86_64-linux.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib;
    with nixpkgs.lib;
    let
      getPackages = f: dir:
        with builtins;
        listToAttrs (map (name: {
          inherit name;
          value = f (dir + "/${name}");
        }) (attrNames (readDir dir)));
      dirs = [ ./pkgs ./gnome/gnome-extension ./gnome/gnome-theme ];
      getPackages' = f: dirs:
        fold (a: b: a // b) { } (map (getPackages f) dirs);
    in eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });
      in rec {
        packages = getPackages' (n: pkgs.callPackage n { }) dirs;
      }) // {
        overlay = final: prev: getPackages' (n: final.callPackage n { }) dirs;
      };
}
