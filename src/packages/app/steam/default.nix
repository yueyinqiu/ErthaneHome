{ config, pkgs, nixpak, lib, ... }:
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

        dbus.policies = {
          "com.steampowered.*" = "own";
        };

        # SteamRT3 (pressure-vessel) 需要在宿主 PID/UTS 命名空间里运行，
        # 否则 re-exec 进 SteamRT runtime 时会卡死在 XOpenIM 之后。
        gpu.provider = lib.mkForce "nixos";

        bubblewrap = {
          dieWithParent = true;

          shareIpc = true;

          sharePid = true;

          shareUts = true;

          tmpfs = [
            "/tmp"
          ];

          bind.dev = [ "/dev" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            "/run/opengl-driver-32"
          ];
        };
      };
  };
in
{
  my.packages.steam = steam.config.env;
  home.packages = [ config.my.packages.steam ];
}