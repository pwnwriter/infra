_:

{
  users.users.pwnwriter = {
    name = "pwnwriter";
    home = "/Users/pwnwriter";
  };

  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  # nixpkgs.hostPlatform = "aarch64-darwin";
  # nix.settings.trusted-users = [
  #   "root"
  #   "pwnwriter"
  # ];

  programs.zsh.enable = true;

  system = {
    stateVersion = 5;
    primaryUser = "pwnwriter";

    defaults = {
      dock = {
        tilesize = 20;
        orientation = "left";
        autohide = true;
        persistent-apps = [
          "/System/Applications/Notes.app"
          "/System/Applications/Calendar.app"
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Messages.app"
          "/System/Applications/Music.app"
        ];
      };

      CustomUserPreferences = {
        # "com.apple.Safari" = {
        #   IncludeInternalDebugMenu = true;
        #   IncludeDevelopMenu = true;
        #   WebKitDeveloperExtrasEnabledPreferenceKey = true;
        #   ShowFullURLInSmartSearchField = true;
        #   AutoOpenSafeDownloads = false;
        #   AutoFillCreditCardData = false;
        #   AutoFillFromAddressBook = false;
        #   AutoFillMiscellaneousForms = false;
        #   AutoFillPasswords = false;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        #   AlwaysRestoreSessionAtLaunch = 1;
        #   ExcludePrivateWindowWhenRestoringSessionAtLaunch = 1;
        #   ShowBackgroundImageInFavorites = 0;
        #   ShowFrequentlyVisitedSites = 1;
        #   ShowHighlightsInFavorites = 1;
        #   ShowPrivacyReportInFavorites = 1;
        #   ShowRecentlyClosedTabsPreferenceKey = 1;
        # };

        "com.apple.screencapture" = {
          location = "~/Documents/screenshots";
          type = "png";

        };
      };

      NSGlobalDomain = {
        _HIHideMenuBar = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };

      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;
      };

      trackpad = {
        Clicking = true;
      };

      loginwindow.LoginwindowText = "Have you been pwned?";
    };

  };
}
