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
  };

  outputs =
    {
      nixpkgs,
      nix-vscode-extensions,
      opencode-flake,
      ...
    }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      overlays.default = final: prev: {
        # VSCode extensions
        vscode-marketplace = nix-vscode-extensions.extensions.${prev.system}.vscode-marketplace;
        open-vsx = nix-vscode-extensions.extensions.${prev.system}.open-vsx;

        # External flake packages
        opencode = opencode-flake.packages.${prev.system}.default;

        # Custom builds
        tsgo = final.buildGoModule {
          pname = "tsgo";
          version = "7.0.0-dev";
          src = inputs.typescript-go;
          vendorHash = pkgs.lib.fakeHash;
          subPackages = [ "cmd/tsgo" ];
          doCheck = false;
        };
      };

      packages.x86_64-linux.tsgo = pkgs.buildGoModule {
        pname = "tsgo";
        version = "7.0.0-dev";
        src = inputs.typescript-go;
        vendorHash = pkgs.lib.fakeHash;
        subPackages = [ "cmd/tsgo" ];
        doCheck = false;
      };
    };
}
