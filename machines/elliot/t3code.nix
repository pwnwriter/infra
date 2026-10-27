# T3 Code server on elliot: remote development from the phone, the web app, or
# another machine, with the agents running here.
#
# Reachability is handled by Tailscale, not by opening ports. The server binds
# its LAN and tailnet addresses (its own default) and never answers on public
# ones, and services.nix only trusts tailscale0 while allowing just 22 on
# everything else. So port 3773 is reachable over the tailnet and nowhere else.
#
# Pair a device once with `t3 pair` (add --tailscale for an HTTPS route), run
# from a shell on this machine.
{
  pkgs,
  config,
  ...
}:
let
  t3code = pkgs.callPackage ../../pkgs/t3code { };
  port = 3773;
  # t3 defaults to ~/.t3; keep state out of $HOME's top level.
  stateDir = "${config.users.users.pwn.home}/.local/state/t3code";
in
{
  # The agents it drives, and git, come from pwn's home-manager profile;
  # the server shells out to them, so they have to be on its PATH.
  systemd.user.services.t3code = {
    description = "T3 Code server";
    documentation = [ "https://github.com/pingdotgg/t3code" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "default.target" ];

    environment = {
      T3CODE_PORT = toString port;
      T3CODE_HOME = stateDir;
    };

    # Prepended to the default unit PATH (systemd appends /bin and /sbin).
    path = [
      "/etc/profiles/per-user/pwn"
      "/run/current-system/sw"
    ];

    serviceConfig = {
      ExecStart = "${t3code}/bin/t3 serve";
      Restart = "on-failure";
      RestartSec = 5;
      # Creates stateDir; threads, settings and project state live there.
      StateDirectory = "t3code";
    };
  };

  # elliot autologins (see desktop.nix), but linger keeps the server up from
  # boot and across logout, which is the point of reaching it from anywhere.
  users.users.pwn.linger = true;

  environment.systemPackages = [ t3code ];
}
