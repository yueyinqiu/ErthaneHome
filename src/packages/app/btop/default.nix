{
  config,
  pkgs,
  ...
}:
let
  btop = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        app.package = pkgs.btop;
        app.binPath = "bin/btop";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;
          sharePid = true;
          shareUts = true;
          shareCgroup = true;

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            "/sys"
          ];
        };
      };
  };
in
{
  my.packages.btop = btop.config.env;
  home.packages = [ config.my.packages.btop ];
}