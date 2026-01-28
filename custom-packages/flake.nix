{
  description = "Custom packages and overlays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    typescript-go = {
      url = "github:microsoft/typescript-go";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-flake.url = "github:anomalyco/opencode";

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
      nixpkgs-unstable,
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

        # oxfmt 0.24.0 (override from nixpkgs-unstable's 0.23.0)
        oxfmt =
          let
            base = nixpkgs-unstable.legacyPackages.${prev.system}.oxfmt;
          in
          base.overrideAttrs (old: rec {
            version = "0.24.0";
            src = final.fetchFromGitHub {
              owner = "oxc-project";
              repo = "oxc";
              tag = "oxfmt_v${version}";
              hash = "sha256-Sg9NtXRuQ0ZruK8a8k5EkeDOJ9v6uzpNzEQ/FY56ioY=";
            };
            env = (old.env or { }) // {
              OXC_VERSION = version;
            };
            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit src;
              hash = "sha256-sgIarCuUmSTAVPVr82rp4dQwzDMWESIbGgkCYEExz6o=";
            };
            pnpmDeps = final.pnpm_10.fetchDeps {
              inherit src version;
              pname = "oxfmt";
              hash = "sha256-U+plQgqApzpTqbiiZdeCIFlEbKzp9shcAousmPv9Pi0=";
              fetcherVersion = 2;
              prePnpmInstall = ''
                substituteInPlace pnpm-workspace.yaml pnpm-lock.yaml \
                  --replace-fail "patchedDependencies:" "_patchedDependencies:"
              '';
            };
          });

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
