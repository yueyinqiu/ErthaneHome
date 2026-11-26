{ pkgs, nix-ttf-ms-win11-auto, chinese-fonts-overlay, ... }: {
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    corefonts
    maple-mono.Normal-NF-CN

    nix-ttf-ms-win11-auto.ttf-ms-win11-auto
    nix-ttf-ms-win11-auto.ttf-ms-win11-auto-zh_cn
    nix-ttf-ms-win11-auto.ttf-ms-win11-fod-auto-hans
    
    chinese-fonts-overlay.foundertype-fonts
    
    (pkgs.writeShellApplication {
      name = "my-fontconfig-find-family";
      text = ''
        fc-list : family | sort -u | grep -i "''$1"
      '';
    })
  ];

  fonts.fontconfig = {
    enable = true;

    antialiasing = true;
    hinting = "full";
    subpixelRendering = "rgb";

    defaultFonts = {
      serif = [ "NSimSun" ];
      sansSerif = [ "Microsoft YaHei" ];
      monospace = [ "NSimSun" ];
    };
  };

}
