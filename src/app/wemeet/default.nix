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
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wemeet;
        app.binPath = "bin/wemeet-xwayland";
        app.extraEntrypoints = [
          "/bin/wemeet"
        ];

        dbus.policies = {
          "com.tencent.wemeet" = "own";
        };

        bubblewrap = {
          dieWithParent = true;

          bind.dev = [ "/dev" ];

          bind.ro = [
            "/etc"
          ];

          bind.rw = [
            [ (sloth.mkdir (sloth.concat' "/tmp/nixpak-" sloth.instanceId)) "/tmp" ]
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
          ];

          env = {
            QT_IM_MODULE = "fcitx";
            EGL_PLATFORM = "x11";
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.wemeet = app.config.env;
  home.packages = [ config.my.packages.wemeet ];
}
