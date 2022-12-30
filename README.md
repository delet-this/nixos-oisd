# nixos-oisd
Flake with a NixOS module for [oisd.nl](https://github.com/sjhgvr/oisd) blocklist, inspired by [StevenBlack hosts flake.nix](https://github.com/StevenBlack/hosts/blob/master/flake.nix)

## Usage
```nix
{
  inputs = {
    nixpkg.url = "github:nixos/nixpkgs/nixos-unstable";
    oisd.url = "github:delet-this/nixos-oisd";
  };
  outputs = { self, nixpkgs, oisd, ... }: {
    nixosConfigurations.my-hostname = {
      system = "x86_64-linux";
      modules = [
        oisd.nixosModule {
          networking.oisd-blocklist = {
            enable = true;
            lists = [ "full" ];
          };
        }
      ];
    };
  };
}
```