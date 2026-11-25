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
          shareIpc = true;
          tmpfs = [
            "/tmp"
            "/etc/ssh"
          ];
          env = {
            BROWSER = "gio open";
            TMPDIR = "/tmp";
          };
          bind.dev = [ "/dev" ];
          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
            "${config.xdg.configHome}/Code"
          ];

          bind.ro = [
            "/etc"
            "/usr"
            "/bin"
            "/nix"
            "/run/current-system"
            "${config.home.homeDirectory}/.nix-profile"
            "${config.home.homeDirectory}/.ssh"
            "${config.xdg.configHome}/git"
            (sloth.envOr "SSH_AUTH_SOCK" "/dev/null")
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
