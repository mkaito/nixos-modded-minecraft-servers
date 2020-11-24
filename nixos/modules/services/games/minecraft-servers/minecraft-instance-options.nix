pkgs: {name, lib, config, ... }: with lib;
let
  mkJvmMxFlag = icfg: optionalString (icfg.jvmMaxAllocation != "") "-Xmx${icfg.jvmMaxAllocation}";
  mkJvmMsFlag = icfg: optionalString (icfg.jvmInitialAllocation != "") "-Xms${icfg.jvmInitialAllocation}";
  mkJvmOptString = icfg: "${mkJvmMxFlag icfg} ${mkJvmMsFlag icfg} ${icfg.jvmOpts}";
in
{
  options = rec {
    enable = mkEnableOption "Enable minecraft server instance ${name}";

    rsyncSSHKeys = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        SSH public keys that will have read/write access to an rsync module
        scoped to the instance state directory.

        This rsync module can be used to manage the instance files.
      '';
    };

    jvmPackage = mkOption {
      type = with types; package;
      default = pkgs.jre8;
      description = ''
        JVM package used to run the server.

        <emphasis>Note:</emphasis> Do not use the
        <literal>jre8_headless</literal> package. Modded minecraft needs
        <literal>awt</literal>.
      '';
    };

    jvmMaxAllocation = mkOption {
      type = with types; str;
      default = "256M";
      description = ''
        Maximum memory allocation pool for the JVM, as set by
        <literal>-Xmx</literal>.

        Default is JVM default. You definitely want to change this.
      '';
    };

    jvmInitialAllocation = mkOption {
      type = with types; str;
      default = "";
      description = ''
        Initial memory allocation pool for the JVM, as set by
        <literal>-Xms</literal>.

        Defaults to not being set.
      '';
    };


    jvmOpts = mkOption {
      type = with types; str;
      default = "-XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M";
      description = ''
        JVM options used to call Minecraft on server startup.

        The default value should serve you well unless you have specific
        needs.

        Note: Do not include <literal>-Xms</literal> or
        <literal>-Xmx</literal> here.

        See <literal>jvmMaxAllocation</literal> for <literal>-Xmx</literal>
        and <literal>jvmInitialAllocation</literal> for
        <literal>-Xms</literal>.
      '';
    };

    jvmOptString = mkOption {
      type = with types; str;
      default = mkJvmOptString config;
      readOnly = true;
      description = ''
        The compiled value of $JVMOPTS, exported as a read-only value.
      '';
    };

    serverConfig = mkOption {
      type = with types; submodule ./minecraft-server-properties.nix;
      description = ''
        Set options for <literal>server.properties</literal>.

        Option names, descriptions, and default values were taken from the
        <link
        linkend="https://minecraft.gamepedia.com/Server.properties">Minecraft
        Gamepedia</link>.

        Any options with dots in their names, such as
        <literal>rcon.password</literal> have had the dot substituted for a
        dash (<literal>rcon-password</literal>).

        <emphasis>NixOS Note:</emphasis> The white list, as well as the list
        of ops, banned players and banned IPs is maintained statefully, either
        by hand or through console commands/rcon.
      '';
    };
  };
}
