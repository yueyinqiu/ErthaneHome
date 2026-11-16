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

        app.package = pkgs.git;
        app.binPath = "bin/git";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            (sloth.concat' sloth.xdgConfigHome "/git")
          ];
        };
      };
  };
in
{
  my.packages.git = app.config.env;

  programs.git = {
    enable = true;
    package = config.my.packages.git;
    settings = {
      user = {
        name = "yueyinqiu";
        email = "yueyinqiu@outlook.com";
      };
      pull.rebase = true;
      alias = {
        ac = "!git add -A && git commit";
      };
    };
    lfs.enable = true;
  };
}