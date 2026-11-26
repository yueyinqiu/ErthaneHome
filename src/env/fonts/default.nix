{ pkgs, nix-wpsoffice-cn, nix-ttf-ms-win11-auto, ... }: {
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    corefonts
    nix-wpsoffice-cn.chinese-fonts
    maple-mono.Normal-NF-CN
    nix-ttf-ms-win11-auto.ttf-ms-win11-auto
    nix-ttf-ms-win11-auto.ttf-ms-win11-auto-zh_cn
    nix-ttf-ms-win11-auto.ttf-ms-win11-fod-auto-hans

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
