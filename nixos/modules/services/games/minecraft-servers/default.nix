{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.modded-minecraft-servers;

  # Server config rendering
  serverPropertiesFile = serverConfig: pkgs.writeText "server.properties"
    (mkOptionText serverConfig);


  encodeOptionValue = value: let
    encodeBool = value: if value then "true" else "false";
    encodeString = value: escape [":" "=" "'"] value;
    typeMap = {
      "bool" = encodeBool;
      "string" = encodeString;
    };
  in
    (typeMap.${builtins.typeOf value} or toString) value;

  mkOptionLine = name: value:
    let
      dotNames = ["query-port" "rcon-password" "rcon-port"];
      fixName = name:
        if elem name dotNames
        then stringAsChars (x: if x == "-" then "." else x) name
        else name;
    in
    "${fixName name}=${encodeOptionValue value}";

  mkOptionText = serverConfig:
  let
    # Merge declared options with extraConfig
    c = (builtins.removeAttrs serverConfig ["extra-options"])
          // serverConfig.extra-options;
  in concatStringsSep "\n"
    (mapAttrsToList mkOptionLine c);

  # Configure rsync access
  mkRsyncdConf = name: pkgs.writeText "rsyncd-minecraft.conf" ''
    log file = /var/lib/${mkInstanceName name}/rsync.log
    [${mkInstanceName name}]
    use chroot = false
    comment = Minecraft server state
    path = /var/lib/${mkInstanceName name}
    read only = false
  '';

  # Render EULA file
  eulaFile = builtins.toFile "eula.txt" ''
    # eula.txt managed by NixOS Configuration
    eula=true
  '';

  mkInstanceName = name: "mc-${name}";
in {
  options = {
    services.modded-minecraft-servers = {
      eula = mkOption {
        type = with types; bool;
        default = false;
        description = ''
          Whether or not you accept the Minecraft EULA
        '';
      };

      instances = mkOption {
        type = with types; attrsOf (submodule (import ./minecraft-instance-options.nix pkgs));
        default = {};
        description = ''
          Define instances of Minecraft servers to run.
        '';
      };
    };
  };

  config = let
    enabledInstances = (filterAttrs (_: x: x.enable) cfg.instances);

    # Attrset options
    eachEnabledInstance = f: mapAttrs' (i: c: nameValuePair (mkInstanceName i) (f i c) ) enabledInstances;

    # List options
    eachEnabledInstance' = f: flatten (mapAttrsToList f enabledInstances);

  in {
    assertions = [
      { assertion = cfg.eula;
        message = "You must accept the Mojang EULA in order to run any servers."; }
    ];

    systemd.services = eachEnabledInstance (name: icfg: {
      description   = "Minecraft Server ${name}";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      path = with pkgs; [ icfg.jvmPackage bash ];

      environment.JVMOPTS = icfg.jvmOptString;

      serviceConfig = let
        fullname = mkInstanceName name;
      in {
        Restart = "always";
        ExecStart = "/var/lib/${fullname}/start.sh";
        User = fullname;
        StateDirectory = fullname;
        WorkingDirectory = "/var/lib/${fullname}";
      };

      preStart = ''
        # Ensure EULA is accepted
        ln -sf ${eulaFile} eula.txt

        # Ensure server.properties is present
        if [[ -f server.properties ]]; then
          mv -f server.properties server.properties.orig
        fi

        # This file must be writeable, because reasons
        cp ${serverPropertiesFile icfg.serverConfig} server.properties
        chmod 644 server.properties
      '';
    });

    users.users = eachEnabledInstance (name: icfg:
      let
        rsyncCmd = ''command="rsync --config=${mkRsyncdConf name} --server --daemon .",no-agent-forwarding,no-port-forwarding,no-user-rc,no-X11-forwarding,no-pty'';
      in {
        description = "Minecraft server service user for instance ${name}";
        isSystemUser = true;
        useDefaultShell = true;
        createHome = true;
        home = "/var/lib/${mkInstanceName name}";
        openssh.authorizedKeys.keys =
          optionals (icfg.rsyncSSHKeys != [])
            map (x: rsyncCmd + " " + x) icfg.rsyncSSHKeys;
      });

    networking.firewall.allowedUDPPorts = eachEnabledInstance'
      (_: icfg: optionals icfg.serverConfig.enable-query [icfg.serverConfig.query-port]);

    networking.firewall.allowedTCPPorts = eachEnabledInstance'
      (_: icfg: [ icfg.serverConfig.server-port ]
            ++ (optionals icfg.serverConfig.enable-query [icfg.serverConfig.query-port])
            ++ (optionals icfg.serverConfig.enable-rcon  [icfg.serverConfig.rcon-port]));

  };
}
