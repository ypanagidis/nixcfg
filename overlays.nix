# modules/overlays.nix
{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default

    (final: prev: {
      vimPlugins = prev.vimPlugins // {
        neovim-ayu = prev.vimUtils.buildVimPlugin {
          name = "neovim-ayu";
          src = inputs.neovim-ayu;
        };
      };
    })
  ];
}
