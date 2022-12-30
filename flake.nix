{
  description = "Oisd blocklist NixOS module.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    oisd = {
      url = "github:sjhgvr/oisd";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, oisd }: 
  let
    inherit (nixpkgs) lib;
  in {
    nixosModule = {config, ...}:
      with lib; 
      let
        cfg = config.networking.oisd-blocklist;
      in {
        options.networking.oisd-blocklist = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Use oisd.nl hosts file as extra hosts.";
          };

          lists = mkOption {
            default = [ "basic" ];
            type = types.listOf types.str;
            description = lib.mdDoc "List of blocklists to use. Valid options: basic, full, extra, nsfw";
            example = [ "full" "extra" "nsfw" ];
          };
        };

        config = mkIf cfg.enable {
          networking.extraHosts = ''
            ${
              lib.lists.foldl
              (acc: listName: acc + (builtins.readFile ("${oisd.outPath}/hosts_" + listName + ".txt")) + "\n")
              ""
              cfg.lists
            }
          '';
        };
      };
  };
}
