{ ... }: {
  programs.snavi.cheats = {
    "thunderbird-thunderbird" = {
      src = ./cheats;
      entry = "thunderbird.json";
    };
  };
}