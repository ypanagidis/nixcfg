{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    # lets you still install extra extensions manually in the UI
    mutableExtensionsDir = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide
        bbenoist.nix

        # Formatting / web dev
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        editorconfig.editorconfig

        # Git
        eamodio.gitlens
      ];

      userSettings = {
        "editor.formatOnSave" = true;
        "files.trimTrailingWhitespace" = true;

        "[javascript]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
        "[typescript]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
        "[json]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
        "[css]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
        "[html]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "alejandra";
      };
    };
  };
}

