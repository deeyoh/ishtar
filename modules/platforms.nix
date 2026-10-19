{ inputs, ... }: {
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;

      config.allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          "terraform"
        ];
    };
  };
}
