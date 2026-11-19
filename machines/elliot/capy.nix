# Capy on elliot: a paired device that agent threads run on, driven from the
# web app or the Capy desktop app on darlene and whiterose.
#
# Nothing listens here and no port is opened. The dock dials out to Capy, so
# the Macs reach it through capy.ai rather than over the tailnet.
#
# Pairing is a one-time manual step and cannot be done from Nix: the first
# `capy dock` run prints a code that must be approved in a browser, and the
# docs are explicit that it needs an interactive terminal so the code never
# reaches a log. Run `capy dock` once as pwn, approve it, then this service
# keeps the machine online. Until then the unit just retries.
{ pkgs, ... }:
let
  capy-dock = pkgs.callPackage ../../pkgs/capy-dock { };
in
{
  systemd.user.services.capy-dock = {
    description = "Capy Dock";
    documentation = [ "https://docs.capy.ai/dock" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "default.target" ];

    # Threads run commands as pwn, so they need pwn's toolchain on PATH.
    path = [
      "/etc/profiles/per-user/pwn"
      "/run/current-system/sw"
    ];

    serviceConfig = {
      ExecStart = "${capy-dock}/bin/capy dock";
      # Unpaired, this exits straight away; a minute between tries keeps the
      # journal quiet until the one-time pairing is done.
      Restart = "on-failure";
      RestartSec = 60;
    };
  };

  environment.systemPackages = [
    capy-dock
    # `capy dock doctor` checks for both; Capy opens and follows pull requests.
    pkgs.gh
  ];
}
