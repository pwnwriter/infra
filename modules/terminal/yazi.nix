{ theme, ... }:
let
  # Evergarden's accent (cursor in Ghostty, GNOME accent, mode pill here).
  accent = theme.green;
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."yazi/init.lua".text = ''
    require("session"):setup {
      sync_yanked = true,
    }
  '';

  # Evergarden tmTheme for syntax-highlighted file previews.
  xdg.configFile."yazi/evergarden.tmTheme".text = theme.tmTheme;

  # Theme generated from the active palette (see modules/theme.nix).
  # Role mapping follows the upstream flavor (github.com/evergardentheme/yazi,
  # yazi.tera) so yazi reads like the neovim theme: muted overlay2 directories,
  # a soft surface0 hover row, and the accent only on mode / tabs / borders.
  xdg.configFile."yazi/theme.toml".text = ''
    [mgr]
    cwd = { fg = "${theme.aqua}" }

    hovered         = { fg = "${theme.text}", bg = "${theme.surface0}" }
    preview_hovered = { fg = "${theme.text}", bg = "${theme.surface0}" }

    find_keyword  = { fg = "${theme.green}", italic = true }
    find_position = { fg = "${theme.text}", bg = "reset", italic = true }

    marker_copied   = { fg = "${theme.yellow}", bg = "${theme.yellow}" }
    marker_cut      = { fg = "${theme.red}", bg = "${theme.red}" }
    marker_marked   = { fg = "${theme.aqua}", bg = "${theme.aqua}" }
    marker_selected = { fg = "${theme.green}", bg = "${theme.green}" }

    count_copied   = { fg = "${theme.crust}", bg = "${theme.yellow}" }
    count_cut      = { fg = "${theme.crust}", bg = "${theme.red}" }
    count_selected = { fg = "${theme.crust}", bg = "${theme.green}" }

    border_symbol = "│"
    border_style  = { fg = "${theme.surface1}" }

    syntect_theme = "~/.config/yazi/evergarden.tmTheme"

    [tabs]
    active   = { fg = "${theme.crust}", bg = "${accent}", bold = true }
    inactive = { fg = "${accent}", bg = "${theme.surface0}" }

    [mode]
    normal_main = { fg = "${theme.crust}", bg = "${accent}", bold = true }
    normal_alt  = { fg = "${accent}", bg = "${theme.surface0}" }

    select_main = { fg = "${theme.crust}", bg = "${theme.pink}", bold = true }
    select_alt  = { fg = "${theme.pink}", bg = "${theme.surface0}" }

    unset_main  = { fg = "${theme.crust}", bg = "${theme.subtext0}", bold = true }
    unset_alt   = { fg = "${theme.subtext0}", bg = "${theme.surface0}" }

    [status]
    sep_left  = { open = "", close = "" }
    sep_right = { open = "", close = "" }

    progress_label  = { fg = "${theme.text}", bg = "${theme.base}", bold = true }
    progress_normal = { fg = "${theme.text}", bg = "${theme.base}" }
    progress_error  = { fg = "${theme.red}", bg = "${theme.base}" }

    perm_type  = { fg = "${theme.blue}" }
    perm_read  = { fg = "${theme.yellow}" }
    perm_write = { fg = "${theme.purple}" }
    perm_exec  = { fg = "${theme.green}" }
    perm_sep   = { fg = "${theme.aqua}" }

    [input]
    border   = { fg = "${accent}" }
    title    = { fg = "${theme.text}" }
    value    = { fg = "${theme.text}" }
    selected = { bg = "${theme.surface0}" }

    [pick]
    border   = { fg = "${accent}" }
    active   = { fg = "${theme.pink}" }
    inactive = { fg = "${theme.text}" }

    [confirm]
    border  = { fg = "${accent}" }
    title   = { fg = "${accent}" }
    body    = { fg = "${theme.text}" }
    list    = { fg = "${theme.text}" }
    btn_yes = { reversed = true }
    btn_no  = {}

    [cmp]
    border   = { fg = "${accent}" }
    active   = { fg = "${theme.pink}", bg = "${theme.surface0}" }
    inactive = { fg = "${theme.text}" }

    [tasks]
    border  = { fg = "${accent}" }
    title   = { fg = "${theme.text}" }
    hovered = { fg = "${theme.text}", bg = "${theme.surface0}" }

    [which]
    mask            = { bg = "${theme.surface1}" }
    cand            = { fg = "${theme.aqua}" }
    rest            = { fg = "${theme.overlay0}" }
    desc            = { fg = "${theme.text}" }
    separator       = "  "
    separator_style = { fg = "${theme.overlay0}" }

    [help]
    on      = { fg = "${theme.pink}" }
    run     = { fg = "${theme.aqua}" }
    desc    = { fg = "${theme.text}" }
    hovered = { fg = "${theme.text}", bg = "${theme.surface0}" }
    footer  = { fg = "${theme.text}" }

    [notify]
    title_info  = { fg = "${theme.aqua}" }
    title_warn  = { fg = "${theme.yellow}" }
    title_error = { fg = "${theme.red}" }

    [spot]
    border   = { fg = "${accent}" }
    title    = { fg = "${accent}" }
    tbl_cell = { fg = "${accent}", reversed = true }
    tbl_col  = { bold = true }

    [filetype]
    rules = [
    	# Media
    	{ mime = "image/*", fg = "${theme.aqua}" },
    	{ mime = "{audio,video}/*", fg = "${theme.yellow}" },

    	# Archives
    	{ mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "${theme.pink}" },

    	# Documents
    	{ mime = "application/{pdf,doc,rtf}", fg = "${theme.green}" },
    	{ mime = "application/vnd.*", fg = "${theme.green}" },

    	# Virtual file system
    	{ mime = "vfs/{absent,stale}", fg = "${theme.surface1}" },

    	# Special file
    	{ url = "*", is = "orphan", bg = "${theme.red}" },
    	{ url = "*", is = "exec"  , fg = "${theme.green}" },

    	# Dummy file
    	{ url = "*", is = "dummy", bg = "${theme.red}" },
    	{ url = "*/", is = "dummy", bg = "${theme.red}" },

    	# Fallback
    	{ url = "*/", fg = "${theme.overlay2}" },
    	{ url = "*", fg = "${theme.subtext1}" },
    ]

    [icon]
    dirs = [
    	{ name = ".config", text = "", fg = "${theme.overlay2}" },
    	{ name = ".git", text = "", fg = "${theme.overlay2}" },
    	{ name = ".github", text = "", fg = "${theme.overlay2}" },
    	{ name = ".npm", text = "", fg = "${theme.overlay2}" },
    	{ name = "Desktop", text = "", fg = "${theme.overlay2}" },
    	{ name = "Development", text = "", fg = "${theme.overlay2}" },
    	{ name = "Developer", text = "", fg = "${theme.overlay2}" },
    	{ name = "Documents", text = "", fg = "${theme.overlay2}" },
    	{ name = "Downloads", text = "", fg = "${theme.overlay2}" },
    	{ name = "Library", text = "", fg = "${theme.overlay2}" },
    	{ name = "Movies", text = "", fg = "${theme.overlay2}" },
    	{ name = "Music", text = "", fg = "${theme.overlay2}" },
    	{ name = "Pictures", text = "", fg = "${theme.overlay2}" },
    	{ name = "Public", text = "", fg = "${theme.overlay2}" },
    	{ name = "Videos", text = "", fg = "${theme.overlay2}" },
    ]
    conds = [
    	# Special files
    	{ if = "orphan", text = "", fg = "${theme.text}" },
    	{ if = "link", text = "", fg = "${theme.subtext0}" },
    	{ if = "block", text = "", fg = "${theme.yellow}" },
    	{ if = "char", text = "", fg = "${theme.yellow}" },
    	{ if = "fifo", text = "", fg = "${theme.yellow}" },
    	{ if = "sock", text = "", fg = "${theme.yellow}" },
    	{ if = "sticky", text = "", fg = "${theme.yellow}" },
    	{ if = "dummy", text = "", fg = "${theme.red}" },

    	# Fallback
    	{ if = "dir", text = "", fg = "${theme.overlay2}" },
    	{ if = "exec", text = "", fg = "${theme.green}" },
    	{ if = "!dir", text = "", fg = "${theme.subtext1}" },
    ]
  '';
}
