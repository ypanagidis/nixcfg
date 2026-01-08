{
  description = "Custom packages and overlays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    typescript-go = {
      url = "github:microsoft/typescript-go";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-flake.url = "github:aodhanhayter/opencode-flake";

    claude = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-vscode-extensions,
      opencode-flake,
      claude,
      winapps,
      ...
    }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      overlays.default = final: prev: {
        # VSCode extensions
        nix-vscode-extensions = {
          vscode-marketplace = nix-vscode-extensions.extensions.${prev.system}.vscode-marketplace;
          open-vsx = nix-vscode-extensions.extensions.${prev.system}.open-vsx;
        };

        # External flake packages
        opencode = opencode-flake.packages.${prev.system}.default;

        claude = claude.packages.${prev.system}.default;

        # Winapps
        winapps = winapps.packages.${prev.system}.winapps;
        winapps-launcher = winapps.packages.${prev.system}.winapps-launcher;

        # Custom builds
        tsgo = final.buildGoModule {
          pname = "tsgo";
          version = "7.0.0-dev";
          src = inputs.typescript-go;
          vendorHash = "sha256-1uZemqPsDxiYRVjLlC/UUP4ZXVCjocIBCj9uCzQHmog=";
          subPackages = [ "cmd/tsgo" ];
          doCheck = false;
        };
      };
    };
}
