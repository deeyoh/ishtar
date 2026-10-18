{ inputs, ... }: {
  imports = [
    inputs.pi-flake.homeManagerModules.default
  ];
  programs.pi-coding-agent = {
    enable = true;

    agentFiles = {
      settings = {
        value = {
          defaultProvider = "openai";
          defaultModel = "gpt-6.1-sol";
          theme = "dark";
          defaultProjectTrust = "ask";
        };
      };
    };
  };
}
