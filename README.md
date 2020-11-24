# NixOS Modded Minecraft Servers

This is a Nix flake with a module `services.modded-minecraft-servers` that allows you
to run multiple instances of modded Minecraft servers.

## Usage

In your `flake.nix`

```nix
{
  inputs.mms.url = "github:mkaito/nixos-modded-minecraft-servers";
}
```

In your server config:

```nix
{ inputs, ... }:
{
  imports = [ inputs.mms.module ];

  services.modded-minecraft-servers = {
    # This is mandatory, sorry.
    eula = true;

    # The name will be used for the state folder and system user.
    # In this case, the folder is `/var/lib/mc-e2es`
    # and the user `mc-e2es`.
    e2es = {
      enable = true;

      # Keys that can access the state of this instance (read/write!) over an rsync module
      # Leave empty to disable
      rsyncSSHKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGguJRLNBsQJ80dEemxeUjBcpF5N7iylGLW4ZMP0eSP8"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBim0Y5S0CXBsRWQsYbEVMrjXUe3l5lLp2gBiZ5mWMO0"
      ];

      serverConfig = {
        # Port must be unique
        server-port = 25566;
        motd = "Welcome to Enigmatica 2: Expert Skyblock";
      };
    };
  };
}
```

### Server configuration

Server configuration is done by setting options under the `serverConfig` attribute.
This is a typed attrset that supports all vanilla settings. If your modpack adds
custom settings, you may define these as key-value pairs in
`serverConfig.extraConfig`.

This will overwrite any `server.properties` file found in the state folder. This
module does not support stateful configuration.

For most modpacks, you can use all the defaults with very minor alterations,
like a worldgen preset.

The server won't run without accepting the EULA. But we also can't just assume
that you've accepted it. This could potentially get me into legal trouble. For
this reason, you have to specify `eula = true` at the top level.

The modules makes no attempt at managing server state.

#### Ports

Each defined instance will need its own ports. By default, rcon and query are
disabled, so you only need to make sure the `serverConfig.server-port` is
unique.

The defined ports will automatically be opened in the system firewall.

If you run multiple instances on the same machine, you might want to look into
defining CNAME and SRV records for each of them, to make it easier for your
friends to connect.

Assuming you have friends. I wouldn't know what that's like.

### Vanilla

I don't run vanilla servers. There's a module in nixpkgs for that though.

### Modded

I have yet to see two modpacks that use the same procedure for installation and
invocation. The latter only got worse with the introduction of Fabric. The
module makes no real attempt at guessing how to package or run your modpack. It
just provides the necessary options to define a folder for you to dump the files
in, and it will call a script `start.sh` in this folder. An environment variable
`$JVMOPTS` will be set based on the nix settings for the instance. Using this
option is up to you in your `start.sh` script.

#### Download and installation

There are no plans to handle this with Nix. Downloading things from Curse Forge
or similar is easy, but every modpack does something slightly different. The
result of this would be a completely separate derivation for each modpack, which
is a fool's errand. And that's before we consider that you almost certainly will
want to override some mod settings.

It is far easier to just download the server pack to your computer, do whatever
it is the modpack author wants you to do to populate files and folders, adjust
things to your liking, and wrap it all up in a `start.sh` script that you either
write yourself or adapt from one of the scripts provided with the modpack.

Bear in mind that if the modpack has mods with native dependencies, such as
OpenComputers, the download script will likely fetch these native dependencies
for your current platform. If your platform is not the same as your servers (eg
Windows vs Linux), then you will want to run the installation process on a
computer with the same platform.

I suggest you just do it in your home folder on the same server you are going to
use.

#### Writing a start script

The package `jre8_headless` is available in `$PATH`, so you may simply call
`java` in your script. The environment variable `$JVMOPTS` will be set based on
your instance configuration. This allows you to handle your flags and memory
with nix, but still let modpack authors do their thing with regard to server
launch.

A simple example:

```sh
exec java -server "${JVMOPTS[@]}" -jar forge-1.12.2-14.23.5.2847-universal.jar nogui"
```

Depending on what exactly the modpack uses to launch, you may or may not be able
to pass the `$JVMOPTS` variable along. In that case, you'll be stuck setting the
flags manually in whatever format they use.

#### Rsync module

If you set `rsyncSSHKeys`, an rsync module will be available at
`ssh://mc-${name}@yourserver:${name}`. This rsync module has
read/write access, so you should only allow people that you trust.

The SSH keys defined here will all have a forced command that invokes rsync with
a specific configuration, defining only a single module with access to the
appropriate minecraft state folder.

### Under the hood

Each defined instance runs as its own user `mc-${name}` and has
its own state folder in `/var/lib/mc-${name}`.

In order to "install" a modpack, you put all the files for the pack in this
folder.

Whether you do this using the configured rsync module or any other way is
irrelevant. Just make sure the entire folder is owned by the correct user.

The server will be run as a systemd unit with the name `mc-${name}`.
