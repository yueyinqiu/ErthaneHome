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

          tmpfs = [
            "/etc/ssh"
            "/tmp"
          ];

          env.PATH = sloth.concat' "${pkgs.git}/bin:" (sloth.env "PATH");

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
            (sloth.concat' sloth.homeDir "/.ssh")
            (sloth.concat' sloth.xdgConfigHome "/git")
            (sloth.envOr "SSH_AUTH_SOCK" "/dev/null")
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