{ ... }: {
  programs.snavi.cheats = {
    "proton-authenticator-proton-authenticator" = {
      src = ./cheats;
      entry = "proton-authenticator.json";
    };
  };
}