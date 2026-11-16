{
  config,
  nixpak,
  pkgs,
  lib,
  ...
}:
let
  vscode = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.vscode;
        app.binPath = "bin/code";

        bubblewrap = {
          tmpfs = ["/tmp"];
          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            "/usr"
            "/run/current-system"
            (sloth.concat' sloth.homeDir "/.nix-profile")
          ];
        };
      };
  };
in
{
  my.packages.vscode = vscode.config.env;

  programs.vscode.enable = true;
  programs.vscode.package = config.my.packages.vscode;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "c";
      text = ''
        ${
          lib.escapeShellArgs [
            "exec"
            "${config.my.packages.niri}/bin/niri"
            "msg"
            "action"
            "spawn"
            "--"
            "${config.my.packages.vscode}/bin/code"
          ]
        } "$PWD"
      '';
    })
  ];
}