{ ... }:

{
  imports = [
    ./common.nix
  ];

  home.file.".config/karabiner/karabiner.json".source = ./karabiner/karabiner.json;

  programs.ssh.matchBlocks.github = {
    identityFile = "~/.ssh/id_ed25519_mbp";
    extraOptions = {
      UseKeychain = "yes";
    };
  };
}
