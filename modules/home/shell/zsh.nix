{ config, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    KEYTIMEOUT = 15;

    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";

    ZDOTDIR = "${config.xdg.configHome}/zsh";

    GOPATH = "${config.xdg.dataHome}/go";

    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";

    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
    SSH_HOME = "${config.xdg.configHome}/ssh/ssh_config";

    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
    CODEX_HOME = "${config.xdg.configHome}/codex";

  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
      ignoreSpace = false;
      save = 15000;
      share = true;
      append = true;
      ignoreAllDups = true;
    };

    shellAliases = {
      vi = "vi -i NONE";
      v = "nvim";
      vim = "nvim";

      cat = "bat";
      cp = "cp -iv";
      bc = "bc -ql";

      wget = "wget --no-hsts";

      ".." = "cd ..";
      "..." = "cd ../../";
    };

    initContent = ''
      autoload -Uz edit-command-line
      zle -N edit-command-line

      stty -ixon
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      bindkey -v '^?' backward-delete-char
      bindkey -M viins 'jk' vi-cmd-mode
      bindkey -M viins '^E' edit-command-line
      bindkey -M vicmd '^E' edit-command-line

      bindkey -s '^y' '^uyazi\n'
      bindkey -s '^z' '^ufg\n'

      function zle-keymap-select() {
        case $KEYMAP in
          vicmd) echo -ne '\e[1 q' ;;
          viins|main) echo -ne '\e[5 q' ;;
        esac
      }

      zle-line-init() {
        zle -K viins
        echo -ne "\e[5 q"
      }

      zle -N zle-keymap-select
      zle -N zle-line-init

      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q'; }
    '';
  };
}
