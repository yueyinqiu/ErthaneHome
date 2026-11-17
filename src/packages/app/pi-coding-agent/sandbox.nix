{ pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

  sandboxConfig = {
    enabled = true;
    network = {
      disabled = true;
      allowAllUnixSockets = true;
    };
    filesystem = {
      allowRead = [ ];
      # The whole launcher view writable. That view is already narrow: only
      # ~/s, ~/.pi/agent, /tmp and an ephemeral root tmpfs exist inside it, and
      # the read-only mounts (/nix, /etc, /usr, the nix profiles) survive
      # because bwrap binds non-recursively.
      allowWrite = [ "/" ];
      # The two deny lists protect different directions:
      #   denyRead  -> bash gets an empty tmpfs over the path (hard read-block);
      #                read/edit tools only enforce it under a named profile.
      #   denyWrite -> hard write-block for read/write/edit tools; for bash it
      #                is a ro-bind mask, correctly applied since 0.9.1 (the
      #                old allowWrite "/" containment built "//" and skipped it).
      denyRead = [ "~/.pi/agent" ];
      denyWrite = [ "~/.pi/agent" ];
      # Explicit /dev/ device passthrough (0.9.3+); the outer nixpak sandbox
      # dev-binds /dev/kvm, and this re-exposes it inside pi-sandbox's own
      # `--dev /dev` (which otherwise hides it).
      allowDevices = [ "/dev/kvm" ];
    };
  };
in
{
  programs.pi-coding-agent.settings.packages = [
    "npm:@xzzpig/pi-sandbox"
  ];

  programs.pi-coding-agent.extraPackages = [
    pkgs.nodejs_latest
    pkgs.bubblewrap
    pkgs.socat
    pkgs.ripgrep
  ];

  home.file.".pi/agent/sandbox.json".source = jsonFormat.generate "pi-sandbox.json" sandboxConfig;
}
