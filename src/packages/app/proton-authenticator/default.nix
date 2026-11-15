{ config, nixpak, pkgs, ... }:
let
  proton-authenticator = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.proton-authenticator;
        app.binPath = "bin/proton-authenticator";

        bubblewrap = {
          dieWithParent = true;

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
          ];
        };
      };
  };
in
{
  my.packages.proton-authenticator = proton-authenticator.config.env;
  home.packages = [ config.my.packages.proton-authenticator ];
}