# Rex server on elliot, so the Mac client can open sessions here.
#
# The login server rather than the shared one: the shared server runs every
# session as the `rex` system account, which has none of pwn's repos, dotfiles
# or agents. The login server identifies the caller and runs a server per
# account as that account, so a session here is a real pwn shell. The two are
# mutually exclusive; they both own /run/rex.
#
# Reachability is Tailscale Serve, which terminates inside tailscaled, so no
# firewall port is opened. Serve listens on 7297 rather than 443 to leave
# ordinary HTTPS to the tailnet alone; the Rex CLI tries both.
{ inputs, ... }:
{
  imports = [ inputs.rex.nixosModules.default ];

  services.rex.loginServer = {
    enable = true;

    # `tailscale:*` is any Tailscale login on the tailnet, which on a personal
    # tailnet is just you. Narrow it to "tailscale:<your-login>" if the tailnet
    # ever gains other people.
    accounts.pwn.principals = [ "tailscale:*" ];

    # Which account a client gets when it names none.
    defaults."tailscale:*" = "pwn";

    tailscaleServe.enable = true;
  };
}
