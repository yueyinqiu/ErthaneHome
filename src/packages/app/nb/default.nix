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

        app.package = pkgs.nb;
        app.binPath = "bin/nb";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;

          tmpfs = [ "/tmp" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            "/run/current-system"
            (sloth.concat' sloth.homeDir "/.nix-profile")
          ];
        };
      };
  };
in
{
  my.packages.nb = app.config.env;

  home.packages = [
    config.my.packages.nb
  ];
}