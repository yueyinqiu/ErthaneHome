{ config, pkgs, nixpak, ... }:
let
  steam = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.steam;
        app.binPath = "bin/steam";

        dbus.enable = false;

        bubblewrap = {
          dieWithParent = true;

          shareIpc = true;

          tmpfs = [
            "/tmp"
          ];

          bind.dev = [ "/dev" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
            (sloth.concat' sloth.runtimeDir "/bus")
          ];

          bind.ro = [
            "/etc"
            "/run/opengl-driver-32"
          ];

          env = {
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.steam = steam.config.env;
  home.packages = [ config.my.packages.steam ];
}