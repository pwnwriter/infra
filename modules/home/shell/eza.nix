{ theme, ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "-T"
      "-L"
      "1"
    ];
  };

  # Theme generated from the active palette (see theme.nix).
  xdg.configFile."eza/theme.yml".text = ''
    colourful: true

    filekinds:
      normal: {foreground: "${theme.text}"}
      directory: {foreground: "${theme.orange}"}
      symlink: {foreground: "${theme.blue}"}
      pipe: {foreground: "${theme.subtext1}"}
      block_device: {foreground: "${theme.orange}"}
      char_device: {foreground: "${theme.orange}"}
      socket: {foreground: "${theme.subtext1}"}
      special: {foreground: "${theme.purple}"}
      executable: {foreground: "${theme.green}"}
      mount_point: {foreground: "${theme.aqua}"}

    perms:
      user_read: {foreground: "${theme.red}", is_bold: true}
      user_write: {foreground: "${theme.yellow}", is_bold: true}
      user_execute_file: {foreground: "${theme.green}", is_bold: true}
      user_execute_other: {foreground: "${theme.green}", is_bold: true}
      group_read: {foreground: "${theme.red}"}
      group_write: {foreground: "${theme.yellow}"}
      group_execute: {foreground: "${theme.green}"}
      other_read: {foreground: "${theme.red}"}
      other_write: {foreground: "${theme.yellow}"}
      other_execute: {foreground: "${theme.green}"}
      special_user_file: {foreground: "${theme.purple}"}
      special_other: {foreground: "${theme.overlay1}"}
      attribute: {foreground: "${theme.overlay2}"}

    size:
      major: {foreground: "${theme.subtext0}"}
      minor: {foreground: "${theme.skye}"}
      number_byte: {foreground: "${theme.subtext1}"}
      number_kilo: {foreground: "${theme.subtext0}"}
      number_mega: {foreground: "${theme.blue}"}
      number_giga: {foreground: "${theme.purple}"}
      number_huge: {foreground: "${theme.purple}"}
      unit_byte: {foreground: "${theme.subtext0}"}
      unit_kilo: {foreground: "${theme.skye}"}
      unit_mega: {foreground: "${theme.purple}"}
      unit_giga: {foreground: "${theme.purple}"}
      unit_huge: {foreground: "${theme.aqua}"}

    users:
      user_you: {foreground: "${theme.text}"}
      user_root: {foreground: "${theme.red}"}
      user_other: {foreground: "${theme.orange}"}
      group_yours: {foreground: "${theme.subtext0}"}
      group_other: {foreground: "${theme.overlay2}"}
      group_root: {foreground: "${theme.red}"}

    links:
      normal: {foreground: "${theme.blue}"}
      multi_link_file: {foreground: "${theme.blue}"}

    git:
      new: {foreground: "${theme.green}"}
      modified: {foreground: "${theme.yellow}"}
      deleted: {foreground: "${theme.orange}"}
      renamed: {foreground: "${theme.aqua}"}
      typechange: {foreground: "${theme.pink}"}
      ignored: {foreground: "${theme.overlay1}"}
      conflicted: {foreground: "${theme.orange}"}

    git_repo:
      branch_main: {foreground: "${theme.subtext0}"}
      branch_other: {foreground: "${theme.purple}"}
      git_clean: {foreground: "${theme.green}"}
      git_dirty: {foreground: "${theme.orange}"}

    security_context:
      colon: {foreground: "${theme.overlay0}"}
      user: {foreground: "${theme.overlay1}"}
      role: {foreground: "${theme.purple}"}
      typ: {foreground: "${theme.surface2}"}
      range: {foreground: "${theme.purple}"}

    file_type:
      image: {foreground: "${theme.yellow}"}
      video: {foreground: "${theme.red}"}
      music: {foreground: "${theme.green}"}
      lossless: {foreground: "${theme.aqua}"}
      crypto: {foreground: "${theme.overlay1}"}
      document: {foreground: "${theme.text}"}
      compressed: {foreground: "${theme.pink}"}
      temp: {foreground: "${theme.orange}"}
      compiled: {foreground: "${theme.snow}"}
      source: {foreground: "${theme.blue}"}

    punctuation: {foreground: "${theme.overlay0}"}
    date: {foreground: "${theme.yellow}"}
    inode: {foreground: "${theme.subtext0}"}
    blocks: {foreground: "${theme.overlay0}"}
    header: {foreground: "${theme.text}"}
    octal: {foreground: "${theme.aqua}"}
    flags: {foreground: "${theme.purple}"}

    symlink_path: {foreground: "${theme.skye}"}
    control_char: {foreground: "${theme.snow}"}
    broken_symlink: {foreground: "${theme.red}"}
    broken_path_overlay: {foreground: "${theme.surface2}"}
  '';
}
