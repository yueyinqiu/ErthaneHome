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

        app.package = pkgs.pi-coding-agent;
        app.binPath = "bin/pi";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;

          tmpfs = [ 
            "/tmp" 
            "/etc/ssh"
          ];

          bind.dev = [ "/dev/kvm" ];

          bind.rw = [
            (sloth.concat' sloth.homeDir "/.pi/agent")
            config.my.paths.s
          ];

          bind.ro = [
            "/nix"
            "/usr"
            "/etc"
            "/bin"
            "/run/current-system"
            (sloth.concat' sloth.xdgStateHome "/nix/profiles")
            (sloth.concat' sloth.homeDir "/.nix-profile")
            (sloth.concat' sloth.homeDir "/.ssh")
            (sloth.concat' sloth.xdgConfigHome "/git")
          ];

          env = {
            PI_CLIPBOARD_OSC52 = "1";
          };
        };
      };
  };
in
{
  my.packages.pi-coding-agent = app.config.env;

  programs.pi-coding-agent = {
    enable = true;
    package = config.my.packages.pi-coding-agent;
  };
}