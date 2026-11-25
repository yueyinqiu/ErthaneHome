{ pkgs, lib, ... }:
let
  paste-image = pkgs.writeShellApplication {
    name = "paste-image";
    runtimeInputs = [
      pkgs.wl-clipboard
      pkgs.coreutils
    ];
    text = ''
      name="$(date +%Y-%m-%d_%T).png"
      while [ -e "$name" ]; do
        name="''${name}_"
      done
      wl-paste -t image/png &> "$name" || true
    '';
  };
in
{
  programs.yazi.keymap.mgr.prepend_keymap = [
    {
      on = "<C-v>";
      run = "shell ${
        lib.escapeShellArg "${paste-image}/bin/paste-image"
      }";
      desc = "Save clipboard image to PNG";
    }
  ];
}