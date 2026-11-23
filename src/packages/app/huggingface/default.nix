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

        app.package = pkgs.python314Packages.huggingface-hub;
        app.binPath = "bin/hf";

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
  my.packages.huggingface = app.config.env;

  home.packages = [
    config.my.packages.huggingface
  ];
}