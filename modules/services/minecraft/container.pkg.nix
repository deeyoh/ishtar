{ config, inputs, ... }: {
  home-manager.users.podman-captain = {
    imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

    virtualisation.quadlet.containers.minecraft-server = {
      autoStart = true;
      containerConfig = {
        image = "docker.io/itzg/minecraft-server:java17";
        labels = {
          "redjaxk.name" = "Minecraft";
        };
        publishPorts = [
          "25565:25565"
          "10.100.0.2:24454:24454/udp"
        ];
        userns = "keep-id";

        environments = {
          EULA = "TRUE";
          TYPE = "AUTO_CURSEFORGE";
          # Tracks the latest release; add CF_FILE_ID to pin a pack version.
          CF_SLUG = "deceasedcraft";
          CF_EXCLUDE_MODS = "default-server-properties";
          CF_OVERRIDES_EXCLUSIONS = "mods/default-server-properties*.jar";
          CF_FORCE_SYNCHRONIZE = "TRUE";
          CURSEFORGE_FILES = "hardcore-revival,balm";
          MEMORY = "6G";

          MOTD = "Ishtar";
          GAMEMODE = "survival";
          DIFFICULTY = "hard";
          HARDCORE = "TRUE";
          OVERRIDE_SERVER_PROPERTIES = "TRUE";

          VIEW_DISTANCE = "6";
          SIMULATION_DISTANCE = "6";

          ONLINE_MODE = "TRUE";
          ENABLE_WHITELIST = "TRUE";
          ENABLE_RCON = "TRUE";

          PVP = "TRUE";
        };

        environmentFiles = [
          config.sops.templates."minecraft-env-whitelist".path
        ];

        volumes = [
          "/var/lib/podman-captain/minecraft-server/deceasedcraft:/data"
        ];
      };
    };
  };
}
