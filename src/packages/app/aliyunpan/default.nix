{
  config,
  nixpak,
  pkgs,
  ...
}:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [ nixpak.nixpakModules.network ];

        app.package = pkgs.aliyunpan;
        app.binPath = "bin/aliyunpan";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
          ];

          bind.ro = [ "/etc" ];
        };
      };
  };
in
{
  my.packages.aliyunpan = app.config.env;

  home.packages = [
    config.my.packages.aliyunpan
  ];
}