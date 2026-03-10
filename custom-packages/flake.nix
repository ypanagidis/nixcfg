{
  description = "Custom packages and overlays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-opencode.url = "github:NixOS/nixpkgs";

    typescript-go = {
      url = "github:microsoft/typescript-go";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-flake = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs-opencode";
    };

    claude = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nordvpn-flake = {
      url = "github:connerohnesorge/nordvpn-flake";
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
      nordvpn-flake,
      ...
    }@inputs:
    {
      nixosModules = {
        nordvpn = nordvpn-flake.nixosModules.default;
        default = nordvpn-flake.nixosModules.default;
      };

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

          # oxfmt 0.33.0 (latest)
          oxfmt =
            let
              base = nixpkgs-unstable.legacyPackages.${system}.oxfmt;
            in
            base.overrideAttrs (old: rec {
              version = "0.33.0";
              src = final.fetchFromGitHub {
                owner = "oxc-project";
                repo = "oxc";
                tag = "oxfmt_v${version}";
                hash = "sha256-k1VW9FbGf/tsVhm/ZIj2yKHgxg0zgk4EEK6MPdMXcys=";
              };
              # No patchedDependencies in 0.33.0, so remove the postPatch
              postPatch = "";
              env = (old.env or { }) // {
                OXC_VERSION = version;
              };
              cargoDeps = final.rustPlatform.fetchCargoVendor {
                inherit src;
                pname = "oxfmt";
                inherit version;
                hash = "sha256-7/lKwf63ky1ffIbdHO3/PKjEXTWQzeHpohu8H4URSzo=";
              };
              pnpmDeps = final.fetchPnpmDeps {
                inherit src version;
                pname = "oxfmt";
                pnpm = final.pnpm_10;
                fetcherVersion = 2;
                hash = "sha256-l1ykoiYrjkRJOnRgZv48Km1vMztwESNnRu1W9WAIAC4=";
              };
            });

          # oxlint 1.48.0 (latest, with oxc_language_server)
          oxlint =
            let
              base = nixpkgs-unstable.legacyPackages.${system}.oxlint;
            in
            base.overrideAttrs (old: rec {
              version = "1.48.0";
              src = final.fetchFromGitHub {
                owner = "oxc-project";
                repo = "oxc";
                tag = "oxlint_v${version}";
                hash = "sha256-k1VW9FbGf/tsVhm/ZIj2yKHgxg0zgk4EEK6MPdMXcys=";
              };
              env = (old.env or { }) // {
                OXC_VERSION = version;
              };
              cargoDeps = final.rustPlatform.fetchCargoVendor {
                inherit src;
                pname = "oxlint";
                inherit version;
                hash = "sha256-7/lKwf63ky1ffIbdHO3/PKjEXTWQzeHpohu8H4URSzo=";
              };
            });

          # Custom builds
          tsgo =
            let
              go126 = nixpkgs-unstable.legacyPackages.${system}.go_1_26;
            in
            final.buildGoModule.override { go = go126; } {
              pname = "tsgo";
              version = "7.0.0-dev";
              src = inputs.typescript-go;
              vendorHash = "sha256-dUO6rCw8BrIJ+igFrntTIro4k1PH69G2J1IWPKsGzfM=";
              subPackages = [ "cmd/tsgo" ];
              doCheck = false;
            };
        }
        // lib.optionalAttrs (hasPackage opencode-flake "default") {
          opencode = opencode-flake.packages.${system}.default.overrideAttrs (old: {
            preBuild = (old.preBuild or "") + ''
              mkdir -p .github
              : > .github/TEAM_MEMBERS
            '';
          });
        }
        // lib.optionalAttrs (hasPackage claude "default") {
          claude = claude.packages.${system}.default;
        }
        // lib.optionalAttrs (hasPackage nordvpn-flake "nordvpn") {
          nordvpn = nordvpn-flake.packages.${system}.nordvpn;
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
