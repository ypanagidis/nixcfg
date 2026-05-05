{ ... }:

{
  imports = [
    ./common.nix
  ];

  programs.ssh.matchBlocks.github = {
    identityFile = "~/.ssh/id_ed25519_mbp";
    extraOptions = {
      UseKeychain = "yes";
    };
  };
}
