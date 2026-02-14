# Nix Config Architecture + macOS Host Setup

This repo is a multi-host flake with shared modules and host-specific overrides.

## High-level layout

```text
flake.nix
flake.lock

hosts/
  common/                     # Cross-platform system defaults
  nixos/
    common/                   # NixOS platform-shared system modules
    nix-pc/                   # NixOS host-specific config
  darwin/
    common/                   # macOS platform-shared system modules
    yiannis-mbp/              # macOS host-specific config

home/
  common.nix                  # Shared Home Manager config (Linux + macOS)
  linux.nix                   # Linux-only Home Manager additions
  darwin.nix                  # macOS-only Home Manager additions
  karabiner/karabiner.json    # Owned Karabiner config for macOS

modules/                      # Reusable HM/system modules
custom-packages/flake.nix     # Single overlay source for custom pkgs
```

## Flake outputs

- NixOS host: `nixosConfigurations.nix-pc` (alias `nixosConfigurations.nixos` is also present)
- macOS host: `darwinConfigurations."yiannis-mbp"`

## Config layering model

- `hosts/common/default.nix`
  - Shared system defaults used by both platforms (for example Nix features and global policy).
- `hosts/nixos/common/*`
  - Shared NixOS system defaults for any Linux machine.
- `hosts/nixos/nix-pc/*`
  - Machine-specific hardware/services for the current desktop.
- `hosts/darwin/common/default.nix`
  - Shared macOS settings (Homebrew, Dock, defaults, Karabiner service, etc).
- `hosts/darwin/yiannis-mbp/default.nix`
  - macOS host identity (hostname/localHostName/computerName, platform).

For Home Manager:

- `home/common.nix` = shared userland config
- `home/linux.nix` = Linux-only packages/config
- `home/darwin.nix` = macOS-only packages/config

## Package strategy

- Primary custom overlay source is `custom-packages/flake.nix`.
- macOS GUI apps are managed declaratively via nix-darwin `homebrew.*`.
- Linux-only packages stay in Linux scopes.
- Some tools are intentionally split:
  - Linux: `pkgs.opencode`, `pkgs.claude`
  - macOS: Homebrew (`opencode` brew + `claude-code` cask)

## Homebrew strategy (declarative)

This repo uses `nix-homebrew` for Homebrew installation/bootstrap + pinned taps.

- Tap definitions live in `flake.nix` under `nix-homebrew.taps`.
- Homebrew packages/casks live in `hosts/darwin/common/default.nix`.
- `mutableTaps = false` means tap changes are done via Nix, not `brew tap` imperatively.

To add a tap:

1. Add an input in `flake.nix` (`flake = false`).
2. Add it to `nix-homebrew.taps`.
3. Rebuild Darwin.

## Fresh macOS setup (new host machine)

These steps assume:

- macOS username is `yiannis`
- repo location is `/Users/yiannis/nixcfg`
- target host output is `yiannis-mbp`

### 1) Install Xcode Command Line Tools

```bash
xcode-select --install
```

### 2) Install Nix (official installer)

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Open a new terminal after install.

### 3) Clone this repo

```bash
git clone <your-repo-url> /Users/yiannis/nixcfg
```

### 4) First nix-darwin activation

```bash
sudo -H nix --extra-experimental-features "nix-command flakes" \
  run github:LnL7/nix-darwin/nix-darwin-25.11#darwin-rebuild -- \
  switch --flake "path:/Users/yiannis/nixcfg#yiannis-mbp"
```

Notes:

- `sudo` is expected for modern nix-darwin activation.
- Use absolute `path:/Users/yiannis/...` flake path to avoid path/home confusion.
- `-H` helps keep root HOME consistent during activation.

### 5) Regular updates

```bash
sudo -H darwin-rebuild switch --flake "path:/Users/yiannis/nixcfg#yiannis-mbp"
```

## Post-setup checks on macOS

- Karabiner-Elements installed and service enabled.
- Raycast installed; Spotlight shortcuts disabled by defaults config.
- Helium Browser is installed (`helium-browser` cask) and default browser is set via activation script (`duti`).
- Dock entries match declarative list.

If a UI setting does not apply immediately, log out/in once.

## Adding another host

### New NixOS host

1. Create `hosts/nixos/<host>/default.nix`.
2. Import:
   - `../../common/default.nix`
   - `../common/default.nix`
   - hardware file + host-specific modules
3. Add to `flake.nix` under `nixosConfigurations`.

### New macOS host

1. Copy `hosts/darwin/yiannis-mbp` to `hosts/darwin/<new-host>`.
2. Update host naming fields and platform if needed.
3. Add output in `flake.nix` under `darwinConfigurations`.
