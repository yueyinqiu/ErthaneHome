{ config, nixpak, pkgs, ... }:
let
  qq = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.qq;
        app.binPath = "bin/qq";

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
            NIXOS_OZONE_WL = "1";
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.qq = qq.config.env;
  home.packages = [ config.my.packages.qq ];
}