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
            [ (sloth.mkdir (sloth.concat' "/tmp/nixpak-" sloth.instanceId)) "/tmp" ]
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
          ];

          env = {
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.proton-authenticator = proton-authenticator.config.env;
  home.packages = [ config.my.packages.proton-authenticator ];
}