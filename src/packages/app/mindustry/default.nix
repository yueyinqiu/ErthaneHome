{ config, nixpak, mindustry-bin, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = mindustry-bin.mindustry-bin-160_7;
        app.binPath = "bin/mindustry";

        bubblewrap = {
          dieWithParent = true;

          sockets.pipewire = true;

          tmpfs = [ "/tmp" ];

          bind.rw = [
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
  my.packages.mindustry = app.config.env;
  home.packages = [ config.my.packages.mindustry ];
}