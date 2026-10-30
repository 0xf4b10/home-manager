{ config, pkgs, ... }: {

  home.username = "fdb";
  home.homeDirectory = "/Users/fdb";
  #dotDir = ".config/zsh"
  #users.defaultUserShell = pkgs.zsh;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.office-code-pro
    pkgs.macpm
    pkgs.macmon
    pkgs.pyright
    pkgs.htop
    pkgs.graphviz
    pkgs.nextpnr
    pkgs.oh-my-zsh
    pkgs.tree-sitter
    pkgs.wget
    pkgs.gambit
    pkgs.uiua
    pkgs.uiua386
    # This creates a single derivation containing the binaries and the packages
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) 
        scheme-medium
        # You can add specific extra packages here if needed, for example:
        # wrapfig
        # capt-of
        ;
    })
    # version control
    pkgs.uv
    pkgs.git
    # cmdline tools
    pkgs.coreutils-full
    pkgs.fd
    pkgs.fzf
    pkgs.gnumake
    pkgs.jq
    pkgs.nodejs_24
    pkgs.pass
    pkgs.ripgrep
    pkgs.tree
    pkgs.zoxide
    # nix-related
    pkgs.nix-info
  ];

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      # General
      ll = "ls -ltG";
      lsd = "ls -d */";

      pd = "pushd `pwd`";
      pp = "popd";

      # Home-manager related.
      hme = "nvim ~/.config/home-manager/home.nix";
      hms = "home-manager switch";
    };
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [
      "history"
    ];
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    # Keep the pre-26.05 legacy defaults (state version predates the change).
    withRuby = true;
    withPython3 = true;

    # Pass home-manager's generated Lua (provider paths) via the nvim wrapper
    # instead of writing ~/.config/nvim/init.lua, which is managed in its own
    # git repo.
    sideloadInitLua = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "fdb";
      user.email = "fabiodebona@gmail.com";
      alias = {
        pu = "push";
        co = "checkout";
        cm = "commit -a -m";
        pr = "push origin master";
        lr = "pull origin master";
        tracked = "ls-tree -r HEAD --name-only";
      };
    };
  };

  programs.tmux = {
    enable = true;

    # Have a sensible prefix (unbinds C-b, binds C-a send-prefix).
    prefix = "C-a";

    # Let's count from 1 (sets both base-index and pane-base-index).
    baseIndex = 1;

    # True color support (fixes colors in Vim/Neovim).
    terminal = "screen-256color";

    extraConfig = ''
      set -g renumber-windows on

      # Intuitive pane splits
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Vim-style pane switching
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set -ga terminal-overrides ",*256color*:Tc"
    '';
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30;
    extraPackages = epkgs: with epkgs; [
      epkgs.uiua-mode
      epkgs.magit
      epkgs.geiser-gambit
    ];
  };

# Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # xdg.configFile."common-lisp/sbclrc".text = ''(require :asdf)'';
}
