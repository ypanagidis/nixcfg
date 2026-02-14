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
      nixpkgs-unstable,
      nix-vscode-extensions,
      opencode-flake,
      claude,
      winapps,
      ...
    }@inputs:
    {
      overlays.default =
        final: prev:
        let
          lib = prev.lib;
          system = prev.stdenv.hostPlatform.system;

          hasSystemPackages =
            flake: builtins.hasAttr "packages" flake && builtins.hasAttr system flake.packages;
          hasPackage =
            flake: packageName:
            hasSystemPackages flake && builtins.hasAttr packageName flake.packages.${system};
        in
        {
          # VSCode extensions
          nix-vscode-extensions = {
            vscode-marketplace = nix-vscode-extensions.extensions.${system}.vscode-marketplace;
            open-vsx = nix-vscode-extensions.extensions.${system}.open-vsx;
          };

          # pscale
          pscale = nixpkgs-unstable.legacyPackages.${system}.pscale;

          # oxfmt 0.24.0 (override from nixpkgs-unstable's 0.23.0)
          oxfmt =
            let
              base = nixpkgs-unstable.legacyPackages.${system}.oxfmt;
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
            vendorHash = "sha256-0IrEB52rj01HKreqbI/gMVeEHk5dxsNIrhm0Ze+aR44=";
            subPackages = [ "cmd/tsgo" ];
            doCheck = false;
          };
        }
        // lib.optionalAttrs (hasPackage opencode-flake "default") {
          opencode = opencode-flake.packages.${system}.default;
        }
        // lib.optionalAttrs (hasPackage claude "default") {
          claude = claude.packages.${system}.default;
        }
        //
          lib.optionalAttrs
            (prev.stdenv.isLinux && hasPackage winapps "winapps" && hasPackage winapps "winapps-launcher")
            {
              winapps = winapps.packages.${system}.winapps;
              winapps-launcher = winapps.packages.${system}.winapps-launcher;
            };
    };
}
