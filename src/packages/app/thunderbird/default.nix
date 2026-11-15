{ config, nixpak, pkgs, ... }:
let
  thunderbird = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.thunderbird;
        app.binPath = "bin/thunderbird";

        # dbus.policies = {
        #   "org.mozilla.thunderbird.*" = "own";
        # };

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
  my.packages.thunderbird = thunderbird.config.env;
  home.packages = [ config.my.packages.thunderbird ];
}