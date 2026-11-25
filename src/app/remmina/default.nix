{
  config,
  pkgs,
  nixpak,
  ...
}:
let
  remmina = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.remmina;
        app.binPath = "bin/remmina";
        app.extraEntrypoints = [
          "/bin/remmina-file-wrapper"
        ];

        dbus.policies = {
          "org.remmina.Remmina" = "own";
        };

        bubblewrap = {
          dieWithParent = true;

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
  my.packages.remmina = remmina.config.env;
  home.packages = [ config.my.packages.remmina ];
}
