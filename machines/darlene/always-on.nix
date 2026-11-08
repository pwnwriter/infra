# darlene is the always-on box: a Rex host the other machines connect to.
#
# Two separate problems are solved here. The Mini must not sleep, or it drops
# off the tailnet and nothing can reach it. And the Rex server on macOS lives
# inside the app rather than in a daemon, so there has to be a logged-in
# session with the app running in it.
_: {
  power = {
    # Display sleep is left alone; it does not affect reachability.
    sleep.computer = "never";

    # Come back by itself after a power cut or a hang, with nobody there.
    restartAfterPowerFailure = true;
    restartAfterFreeze = true;
  };

  # Without this a reboot stops at the login window and the Rex server never
  # starts. Requires FileVault to be off: FileVault blocks auto-login.
  system.defaults.loginwindow.autoLoginUser = "pwnwriter";

  # Start Rex with the session. Addressed by bundle id rather than app name so
  # it keeps working when "Rex Beta.app" is eventually renamed.
  launchd.user.agents.rex-app.serviceConfig = {
    ProgramArguments = [
      "/usr/bin/open"
      "-b"
      "com.superlogical.rex"
    ];
    RunAtLoad = true;
  };
}
