{ lib, ... }:
with lib;
{
  options = {
    allow-flight = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Allows users to use flight on the server while in Survival mode, if
        they have a mod that provides flight installed.

        With allow-flight enabled, griefers may become more common, because
        it makes their work easier. In Creative mode, this has no effect.

        <itemizedlist>
        <listitem><emphasis>false</emphasis> - Flight is not allowed
        (players in air for at least 5 seconds get kicked).</listitem>
        <listitem><emphasis>true</emphasis> - Flight is allowed, and used
        if the player has a fly mod installed.</listitem>
        </itemizedlist>
      '';
    };
    allow-nether = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Allows players to travel to the Nether.

        <itemizedlist>
        <listitem><emphasis>false</emphasis> - Nether portals do not
        work.</listitem>
        <listitem><emphasis>true</emphasis> - The server allows portals to
        send players to the Nether.</listitem>
        </itemizedlist>
      '';
    };
    broadcast-console-to-ops = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Send console command outputs to all online operators.
      '';
    };
    broadcast-rcon-to-ops = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Send rcon console command outputs to all online operators.
      '';
    };
    difficulty = mkOption {
      type = with types; enum ["peaceful" "easy" "normal" "hard"];
      default = "easy";
      description = ''
        Defines the difficulty (such as damage dealt by mobs and the way
        hunger and poison affects players) of the server.
      '';
    };
    enable-command-block = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Enables command blocks
      '';
    };
    enable-jmx-monitoring = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Exposes an MBean with the Object name
        <literal>net.minecraft.server:type=Server</literal> and two
        attributes <literal>averageTickTime</literal> and
        <literal>tickTimes</literal> exposing the tick times in
        milliseconds.

        In order for enabling JMX on the Java runtime you also need to add
        a couple of JVM flags to the startup as documented
        <link linkend="https://docs.oracle.com/javase/8/docs/technotes/guides/management/agent.html">
        here</link>.
      '';
    };
    enable-rcon = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Enables remote access to the server console.
      '';
    };
    sync-chunk-writes = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Enables synchronous chunk writes.
      '';
    };
    enable-status = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Makes the server appear as "online" on the server list.

        If set to false, it will suppress replies from clients. This means
        it will appear as offline, but will still accept connections.
      '';
    };
    enable-query = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Enables GameSpy4 protocol server listener. Used to get information
        about server.
      '';
    };
    entity-broadcast-range-percentage = mkOption {
      type = with types; ints.between 0 500;
      default = 100;
      description = ''
        Controls how close entities need to be before being sent to clients. Higher
        values means they'll be rendered from farther away, potentially causing more
        lag. This is expressed the percentage of the default value. For example, setting
        to 50 will make it half as usual. This mimics the function on the client video
        settings (not unlike Render Distance, which the client can customize so long as
        it's under the server's setting).

        Accepted values: integers 0-500
      '';
    };
    force-gamemode = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Force players to join in the default game mode.

        <itemizedlist>
        <listitem><emphasis>false</emphasis> - Players join in the gamemode they left in.</listitem>
        <listitem><emphasis>true</emphasis> - Players always join in the default gamemode.</listitem>
        </itemizedlist>
      '';
    };
    function-permission-level = mkOption {
      type = with types; ints.between 1 4;
      default = 2;
      description = ''
        Sets the default permission level for functions.
      '';
    };
    gamemode = mkOption {
      type = with types; enum ["survival" "creative" "adventure" "spectator"];
      default = "survival";
      description = ''
        Defines the mode of gameplay.
      '';
    };
    generate-structures = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Defines whether structures (such as villages) can be generated.

        <itemizedlist>
        <listitem><emphasis>false</emphasis> - Structures are not generated in new chunks.</listitem>
        <listitem><emphasis>true</emphasis> - Structures are generated in new chunks.</listitem>
        </itemizedlist>

        <emphasis>Note:</emphasis> Dungeons still generate if this is set to false.
      '';
    };
    generator-settings = mkOption {
      type = with types; lines;
      default = "";
      description = ''
        The settings used to customize world generation. Follow <link
        linkend="https://minecraft.gamepedia.com/Java_Edition_level_format#generatorOptions_tag_format">its
        format</link> and write the corresponding JSON string.
        <literal>:</literal> are automatically escaped.
      '';
    };
    hardcore = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        If set to true, server difficulty is ignored and set to hard and
        players are set to spectator mode if they die.
      '';
    };
    level-name = mkOption {
      type = with types; str;
      default = "world";
      description = ''
        The "level-name" value is used as the world name and its folder
        name. The player may also copy their saved game folder here, and
        change the name to the same as that folder's to load it instead.

        Characters such as ' (apostrophe) may need to be escaped by adding
        a backslash before them.
      '';
    };
    level-seed = mkOption {
      type = with types; str;
      default = "";
      description = ''
        Sets a world seed for the player's world, as in Singleplayer. The
        world generates with a random seed if left blank.

        Some examples are: minecraft, 404, 1a2b3c.
      '';
    };
    level-type = mkOption {
      type = with types; enum ["default" "flat" "largeBiomes" "amplified" "buffet"];
      default = "default";
      description = ''
        Determines the type of map that is generated.

        <itemizedlist>
        <listitem>
        <emphasis>default</emphasis> - Standard world with hills, valleys, water, etc.
        </listitem>
        <listitem>
        <emphasis>flat</emphasis> - A flat world with no features, can be modified with generator-settings.
        </listitem>
        <listitem>
        <emphasis>largeBiomes</emphasis> - Same as default but all biomes are larger.
        </listitem>
        <listitem>
        <emphasis>amplified</emphasis> - Same as default but world-generation height limit is increased.
        </listitem>
        <listitem>
        <emphasis>buffet</emphasis> - Only for 1.15 or before. Same as default unless generator-settings is set.
        </listitem>
        </itemizedlist>
      '';
    };
    max-players = mkOption {
      type = with types; ints.positive;
      default = 20;
      description = ''
        The maximum number of players that can play on the server at the
        same time. Note that more players on the server consume more
        resources. Note also, op player connections are not supposed to
        count against the max players, but ops currently cannot join a
        full server. However, this can be changed by going to the file
        called ops.json in the player's server directory, opening it,
        finding the op that the player wants to change, and changing the
        setting called bypassesPlayerLimit to true (the default is false).
        This means that that op does not have to wait for a player to
        leave in order to join. Extremely large values for this field
        result in the client-side user list being broken.
      '';
    };
    max-tick-time = mkOption {
      type = with types; int;
      default = 60000;
      description = ''
        The maximum number of milliseconds a single tick may take before
        the server watchdog stops the server with the message, A single
        server tick took 60.00 seconds (should be max 0.05); Considering
        it to be crashed, server will forcibly shutdown. Once this
        criterion is met, it calls System.exit(1).

        <itemizedlist>
        <listitem>
        <emphasis>-1</emphasis> - disable watchdog entirely (this disable option was added in 14w32a)
        </listitem>
        </itemizedlist>
      '';
    };
    max-world-size = mkOption {
      type = with types; ints.between 1 29999984;
      default = 29999984;
      description = ''
        This sets the maximum possible size in blocks, expressed as a
        radius, that the world border can obtain. Setting the world border
        bigger causes the commands to complete successfully but the actual
        border does not move past this block limit. Setting the
        max-world-size higher than the default doesn't appear to do
        anything.

        Examples:

        <itemizedlist>
        <listitem>
        Setting max-world-size to 1000 allows the player to have a 2000×2000 world border.
        </listitem>
        <listitem>
        Setting max-world-size to 4000 gives the player an 8000×8000 world border
        </listitem>
        </itemizedlist>
      '';
    };
    motd = mkOption {
      type = with types; str;
      default = "A Minecraft Server";
      description = ''
        This is the message that is displayed in the server list of the client, below the name.

        <itemizedlist>
        <listitem>
        The MOTD supports <link
        linkend="https://minecraft.gamepedia.com/Formatting_codes#Use_in_server.properties_and_pack.mcmeta">color
        and formatting codes</link>.
        </listitem>
        <listitem>
        The MOTD supports special characters, such as "♥". However, such
        characters must be converted to escaped Unicode form. An online
        converter can be found <link
        linkend="http://www.freeformatter.com/string-utilities.html#charinfo">here</link>.
        </listitem>
        <listitem>
        If the MOTD is over 59 characters, the server list may report a communication error.
        </listitem>
        </itemizedlist>
      '';
    };
    network-compression-threshold = mkOption {
      type = with types; int;
      default = 256;
      description = ''
        By default it allows packets that are n-1 bytes big to go
        normally, but a packet of n bytes or more gets compressed down.
        So, a lower number means more compression but compressing small
        amounts of bytes might actually end up with a larger result than
        what went in.

        <itemizedlist>
        <listitem>
        <emphasis>-1</emphasis> - disable compression entirely
        </listitem>
        <listitem>
        <emphasis>0</emphasis> - compress everything
        </listitem>
        </itemizedlist>

        <emphasis>Note:</emphasis> The Ethernet spec requires that packets
        less than 64 bytes become padded to 64 bytes. Thus, setting a
        value lower than 64 may not be beneficial. It is also not
        recommended to exceed the MTU, typically 1500 bytes.
      '';
    };
    online-mode = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Server checks connecting players against Minecraft account
        database. Set this to false only if the player's server is not
        connected to the Internet. Hackers with fake accounts can connect
        if this is set to false! If minecraft.net is down or inaccessible,
        no players can connect if this is set to true. Setting this
        variable to off purposely is called "cracking" a server, and
        servers that are present with online mode off are called "cracked"
        servers, allowing players with unlicensed copies of Minecraft to
        join.

        <itemizedlist>
        <listitem>
        <emphasis>true</emphasis> - Enabled. The server assumes it has
        an Internet connection and checks every connecting player.
        </listitem>
        <listitem>
        <emphasis>false</emphasis> - Disabled. The server does not
        attempt to check connecting players.
        </listitem>
        </itemizedlist>
      '';
    };
    op-permission-level = mkOption {
      type = with types; ints.between 1 4;
      default = 4;
      description = ''
        Sets the default permission level for ops when using /op. All
        levels inherit abilities and commands from levels before them.

        <itemizedlist>
        <listitem>
        <emphasis>1</emphasis> - Ops can bypass spawn protection.
        </listitem>
        <listitem>
        <emphasis>2</emphasis> - Ops can use all singleplayer cheats
        commands (except <literal>/publish</literal>, as it is not on
        servers; along with <literal>/debug</literal>) and use command
        blocks. Command blocks, along with Realms owners/operators,
        have the same permissions as this level.
        </listitem>
        <listitem>
        <emphasis>3</emphasis> - Ops can use most
        multiplayer-exclusive commands, including
        <literal>/debug</literal>, and commands that manage players
        (<literal>/ban</literal>, <literal>/op</literal>, etc).
        </listitem>
        <listitem>
        <emphasis>4</emphasis> - Ops can use all commands including
        <literal>/stop</literal>, <literal>/save-all</literal>,
        <literal>/save-on</literal>, and <literal>/save-off</literal>.
        </listitem>
        </itemizedlist>
      '';
    };
    player-idle-timeout = mkOption {
      type = with types; int;
      default = 0;
      description = ''
        If non-zero, players are kicked from the server if they are idle
        for more than that many minutes.

        <emphasis>Note:</emphasis> Idle time is reset when the server
        receives one of the following packets:

        <itemizedlist>
        <listitem>Click Window</listitem>
        <listitem>Enchant Item</listitem>
        <listitem>Update Sign</listitem>
        <listitem>Player Digging</listitem>
        <listitem>Player Block Placement</listitem>
        <listitem>Held Item Change</listitem>
        <listitem>Animation (swing arm)</listitem>
        <listitem>Entity Action</listitem>
        <listitem>Client Status</listitem>
        <listitem>Chat Message</listitem>
        <listitem>Use Entity</listitem>
        </itemizedlist>
      '';
    };
    prevent-proxy-connections = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        If the ISP/AS sent from the server is different from the one from
        Mojang's authentication server, the player is kicked

        <itemizedlist>
        <listitem><emphasis>true</emphasis> - Enabled. Server prevents users from using vpns or proxies.</listitem>
        <listitem><emphasis>false</emphasis> - Disabled. The server doesn't prevent users from using vpns or proxies.</listitem>
        </itemizedlist>
      '';
    };
    pvp = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Enable PvP on the server. Players shooting themselves with arrows
        receive damage only if PvP is enabled.

        <itemizedlist>
        <listitem>
        <emphasis>true</emphasis> - Players can kill each other.
        </listitem>
        <listitem>
        <emphasis>false</emphasis> - Players cannot kill other players
        (also known as <emphasis>Player versus Environment
        (PvE)</emphasis>).
        </listitem>
        </itemizedlist>

        <emphasis>Note:</emphasis> Indirect damage sources spawned by
        players (such as lava, fire, TNT and to some extent water, sand
        and gravel) still deal damage to other players.
      '';
    };
    query-port = mkOption {
      type = with types; port;
      default = 25565;
      description = ''
        Minecraft: <literal>query.port</literal>

        Sets the port for the query server (see <literal>enable-query</literal>).
      '';
    };
    rate-limit = mkOption {
      type = with types; int;
      default = 0;
      description = ''
        Sets the maximum amount of packets a user can send before getting
        kicked. Setting to 0 disables this feature.
      '';
    };
    rcon-password = mkOption {
      type = with types; str;
      default = "";
      description = ''
        Minecraft: <literal>rcon.password</literal>.

        Sets the password for RCON: a remote console protocol that can
        allow other applications to connect and interact with a Minecraft
        server over the internet.
      '';
    };
    rcon-port = mkOption {
      type = with types; port;
      default = 25575;
      description = ''
        Minecraft: <literal>rcon.port</literal>.

        Sets the RCON network port.
      '';
    };
    resource-pack = mkOption {
      type = with types; str;
      default = "";
      description = ''
        Optional URI to a resource pack. The player may choose to use it.

        The resource pack may not have a larger file size than 100 MiB
        (Before 1.15: 50 MiB (≈ 50.4 MB)). Note that download success or
        failure is logged by the client, and not by the server.
      '';
    };
    resource-pack-sha1 = mkOption {
      type = with types; str;
      default = "";
      description = ''
        Optional SHA-1 digest of the resource pack, in lowercase
        hexadecimal. It is recommended to specify this, because it is used
        to verify the integrity of the resource pack.

        <emphasis>Note:</emphasis> If the resource pack is any different,
        a yellow message "Invalid sha1 for resource-pack-sha1" appears in
        the console when the server starts. Due to the nature of hash
        functions, errors have a tiny probability of occurring, so this
        consequence has no effect.
      '';
    };
    require-resource-pack = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        When this option is enabled (set to true), players will be
        prompted for a response and will be disconnected if they decline
        the required pack.
      '';
    };
    server-ip = mkOption {
      type = with types; str;
      default = "";
      description = ''
        The player should set this if they want the server to bind to a
        particular IP. It is strongly recommended that the player leaves
        server-ip blank.

        Set to blank, or the IP the player want their server to run
        (listen) on.
      '';
    };
    server-port = mkOption {
      type = with types; port;
      default = 25565;
      description = ''
        TCP Port on which this instance will be listening.
      '';
    };
    snooper-enabled = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Sets whether the server sends snoop data regularly to
        http://snoop.minecraft.net.
      '';
    };
    spawn-animals = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Determines if animals can spawn.
      '';
    };
    spawn-monsters = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Determines if monsters can spawn.

        This setting has no effect if difficulty = 0 (peaceful). If
        difficulty is not = 0, a monster can still spawn from a spawner.
      '';
    };
    spawn-npcs = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Determines whether villagers can spawn.
      '';
    };
    spawn-protection = mkOption {
      type = with types; int;
      default = 16;
      description = ''
        Determines the side length of the square spawn protection area as
        2x+1. Setting this to 0 disables the spawn protection. A value of
        1 protects a 3×3 square centered on the spawn point. 2 protects
        5×5, 3 protects 7×7, etc. This option is not generated on the
        first server start and appears when the first player joins. If
        there are no ops set on the server, the spawn protection is
        disabled automatically as well.
      '';
    };
    use-native-transport = mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Linux server performance improvements: optimized packet sending/receiving on Linux
      '';
    };
    view-distance = mkOption {
      type = with types; ints.between 3 32;
      default = 10;
      description = ''
        Sets the amount of world data the server sends the client,
        measured in chunks in each direction of the player (radius, not
        diameter). It determines the server-side viewing distance.
      '';
    };
    white-list = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Enables a whitelist on the server.

        With a whitelist enabled, users not on the whitelist cannot
        connect. Intended for private servers, such as those for real-life
        friends or strangers carefully selected via an application
        process, for example.

        <emphasis>Note:</emphasis> Ops are automatically whitelisted, and
        there is no need to add them to the whitelist.

        <emphasis>NixOS Note:</emphasis> The whitelist is maintained statefully,
        either manually or through console commands.
      '';
    };
    enforce-white-list = mkOption {
      type = with types; bool;
      default = false;
      description = ''
        Enforces the whitelist on the server.

        When this option is enabled, users who are not present on the
        whitelist (if it's enabled) get kicked from the server after the
        server reloads the whitelist file.
      '';
    };
    extra-options = mkOption {
      type = with types; attrs;
      default = {};
      example = options.literalExample ''
        {
        }
      '';
      description = ''
        Extra options to be appended to <literal>server.properties</literal>.

        Some modpacks require custom settings to work, and usually ship them in
        their default <literal>server.properties</literal> file.

        This should be a one-dimensional attrset. Values will be automatically
        escaped, but property names will not.
      '';
    };

  };
}
