{ pkgs, ... }:
{
  programs.vscode.profiles.default.userSettings = {
    "nixEnvSelector.nixFile" = ''''${workspaceFolder}/flake.nix'';
    "nixEnvSelector.useFlakes" = true;
    "nixEnvSelector.flakeShell" = "default";
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    "nix.serverSettings" = {
      "nixd" = {
        "formatting" = {
          "command" = [ "${pkgs.nixfmt}/bin/nixfmt" ];
        };
      };
    };
  };
}
