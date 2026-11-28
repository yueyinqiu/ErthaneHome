{
  config,
  nixpak,
  pkgs,
  ...
}:
let
  wps = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wpsoffice-cn;
        app.binPath = "bin/wps";
        app.extraEntrypoints = [
          "/bin/wpp"
          "/bin/et"
          "/bin/wpspdf"
        ];

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
            "/bin"
          ];

          env = {
            QT_IM_MODULE = "fcitx";
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.wps = wps.config.env;
  home.packages = [ config.my.packages.wps ];
}
