{ config, nixpak, pkgs, lib, ... }:
let
  firefox = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.firefox;
        app.binPath = "bin/firefox";

        dbus.policies = {
          "org.mozilla.firefox.*" = "own";
        };

        bubblewrap = {
          dieWithParent = true;

          tmpfs = [ "/tmp" ];

          bind.dev = [ "/dev" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            "${config.xdg.configHome}/mozilla/firefox"
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
          ];

          env = {
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.firefox = firefox.config.env;

  programs.firefox = {
    enable = true;
    package = config.my.packages.firefox;

    profiles.default = {
      isDefault = true;

      search = {
        default = "bing";
        privateDefault = "bing";
      };

      settings = {
        "services.sync.prefs.sync.browser.link.open_newwindow.override.external" = true;
        "services.sync.prefs.sync.browser.aboutConfig.showWarning" = true;
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        "services.sync.prefs.sync.browser.toolbars.bookmarks.visibility" = true;
        "services.sync.prefs.sync.browser.tabs.loadBookmarksInTabs" = true;
      };
    };
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "f";
      text = lib.escapeShellArgs [
        "exec"
        "${config.my.packages.niri}/bin/niri"
        "msg"
        "action"
        "spawn"
        "--"
        "${config.my.packages.firefox}/bin/firefox"
      ];
    })
  ];
}