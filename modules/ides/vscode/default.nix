{ config, pkgs, ... }:
let
  # From nix-vscode-extensions overlay:
  # pkgs.nix-vscode-extensions.{vscode-marketplace, open-vsx, ...}
  mkt = pkgs.nix-vscode-extensions.vscode-marketplace;

  settingsRaw = builtins.readFile ./settings.json;
  keybindingsRaw = builtins.readFile ./keybindings.json;

  terminalExecSetting =
    if pkgs.stdenv.isDarwin then
      "\"terminal.external.osxExec\": \"Ghostty.app\","
    else
      "\"terminal.external.linuxExec\": \"konsole\",";

  # Patch terminal key + hardcoded node path.
  settingsPatched =
    builtins.replaceStrings
      [
        "\"terminal.external.osxExec\": \"Ghostty.app\","
        "/Users/yiannis/.nvm/versions/node/v24.10.0/bin/node"
      ]
      [
        terminalExecSetting
        "${config.home.profileDirectory}/bin/node"
      ]
      settingsRaw;

  # You only had cmd+i in your keybindings; patch to something usable on Linux.
  keybindingsPatched =
    if pkgs.stdenv.isDarwin then
      keybindingsRaw
    else
      builtins.replaceStrings [ "\"cmd+i\"" ] [ "\"ctrl+alt+i\"" ] keybindingsRaw;
in
{
  home.packages = [
    pkgs.nixfmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    # Keep this if you still want to install random extras manually in the UI.
    mutableExtensionsDir = false;

    profiles.default.extensions = [
      # Vim + TS native preview
      mkt.vscodevim.vim
      mkt.typescriptteam."native-preview"

      # Your existing stuff (marketplace versions)
      mkt.jnoortheen."nix-ide"
      mkt.bbenoist.nix
      mkt.esbenp."prettier-vscode"
      mkt.dbaeumer."vscode-eslint"
      mkt.editorconfig.editorconfig
      mkt.eamodio.gitlens

      #Themes
      mkt.sdras."night-owl"
      mkt.teabyii.ayu
    ];
  };

  # Write your JSONC files exactly (VS Code accepts comments even though it's .json).
  xdg.configFile."Code/User/settings.json".text = settingsPatched;
  xdg.configFile."Code/User/keybindings.json".text = keybindingsPatched;
}
