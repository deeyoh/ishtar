{
  flake.modules.homeManager.zsh = { pkgs, ... }: {
    home.packages = with pkgs; [
      pure-prompt
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
      };

      shellAliases = {
        rebuild = "sudo darwin-rebuild switch --flake ~/ishtar#gamma";
        check = "sudo darwin-rebuild check --flake ~/ishtar#gamma";
        rez = "source ~/.zshrc";
      };

      initContent = ''
        if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
          tmux attach-session -t default || tmux new-session -s default
        fi

        zstyle ':prompt:pure:environment:nix-shell' show no
        export VIRTUAL_ENV_DISABLE_PROMPT=1
        export DIRENV_LOG_FORMAT=""

        nix_shell_prompt_info() {
          if [[ -n "$IN_NIX_SHELL" || -n "$DIRENV_DIR" ]]; then
            local shell_name="''${NIX_SHELL_NAME}"
            if [[ -z "$shell_name" ]]; then
              shell_name="nix"
            fi

            echo "%F{blue}($shell_name)%f "
          fi
        }

        fpath+=(${pkgs.pure-prompt}/share/zsh/site-functions)
        autoload -U promptinit
        promptinit
        prompt pure
        PURE_PROMPT_SYMBOL="λ"

        eval "$(direnv hook zsh)"
        PROMPT='$(nix_shell_prompt_info)'$PROMPT
      '';
    };
  };
}
