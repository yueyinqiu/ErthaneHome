{
  config,
  nixpak,
  pkgs,
  ...
}:
let
  mpv = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.mpv;
        app.binPath = "bin/mpv";
        app.extraEntrypoints = [
          "/bin/umpv"
          "/bin/mpv_identify.sh"
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
          ];

          env = {
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.mpv = mpv.config.env;
  home.packages = [ config.my.packages.mpv ];
}
