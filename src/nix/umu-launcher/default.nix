{
  config,
  nixpak,
  pkgs,
  ...
}:
let
  umu-launcher = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.umu-launcher;
        app.binPath = "bin/umu-run";

        dbus.enable = false;
        
        bubblewrap = {
          dieWithParent = true;

          tmpfs = [ "/tmp" ];

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
  my.packages.umu-launcher = umu-launcher.config.env;
  home.packages = [ config.my.packages.umu-launcher ];
}