{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        UserKnownHostsFile = "${config.xdg.dataHome}/ssh/known_hosts";
        IdentityFile = "${config.xdg.dataHome}/ssh/id_rsa";
        AddKeysToAgent = "yes";
        SetEnv = {
          TERM = "xterm-256color";
        };
      }
      // (if pkgs.stdenv.isDarwin then { UseKeychain = "yes"; } else { });

      "fawn" = {
        User = "pwn";
        Hostname = "192.168.1.174";
      };

      # NixOS laptop (Precision 7740). Tailscale MagicDNS name — reachable on
      # LAN and from anywhere. Node name follows its hostname ("elliot").
      "elliot" = {
        User = "pwn";
        Hostname = "elliot";
      };

      "eipi" = {
        User = "pwn";
        Hostname = "161.153.39.31";
        Port = 6969;
      };

      # Ubuntu server (home-manager only, user eipi).
      "dom" = {
        User = "eipi";
        Hostname = "167.233.193.30";
        Port = 6969;
      };
    };
  };
}
