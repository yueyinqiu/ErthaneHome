{ config, nixpak, baidunetdisk, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = baidunetdisk.baidunetdisk;
        app.binPath = "bin/baidunetdisk";

        bubblewrap = {
          dieWithParent = true;

          bind.ro = [
            "${config.home.homeDirectory}/.nix-profile"
            "${config.xdg.stateHome}/nix/profiles"
          ];

          tmpfs = [
            (sloth.envOr "TMPDIR" "/tmp")
          ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
          ];
        };
      };
  };
in
{
  my.packages.baidunetdisk = app.config.env;
  home.packages = [ config.my.packages.baidunetdisk ];
}