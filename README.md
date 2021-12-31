> :warning: **This is hacky**: The method leveraged here is temporary until a better method of cache busting modules exits. It doesn't work that well, is poorly put together and is an all around pain. Use with caution.

# roblox-testservice-watcher

This is a Roblox Studio plugin to automatically run unit tests within Studio when a script in a watched directory is changed, with a fresh `ModuleScript` require cache.

This plugin is designed to be used with [Rojo](https://github.com/Roblox/rojo), however it can also be used for development entirely within Studio.

This plugin is heavily inspired by GollyGreg's [rbx-plugin-testServiceWatcher](https://github.com/benbrimeyer/rbx-plugin-testServiceWatcher/). The key improvements in this version is that the DataModel is not run each time a test is run, making it faster and fixing a nasty crash caused by cyclical tests running in the original.

## Details

Whenever a script inside a 'watched' directory is changed, all scripts inside `TestService` will run with a fresh require cache.

'Watched' directories are defined by the user in a `ModuleScript` named `__WatcherDirectories` inside `TestService`. Yours may look something like this:

```lua
return {
    game:GetService("TestService"),
    game:GetService("ReplicatedStorage").Source,
    game:GetService("ServerScriptService").Source,
    game:GetService("StarterPlayer").StarterPlayerScripts
}
```

Changes made to `__WatcherDirectories` will take effect immediately (ie. it is not cached).

## Installation Guide

Download the plugin from the [asset library](ADD_URL_HERE) to have it managed in Studio.

You can also download the `rbxm` from the [releases page](https://github.com/OrbitalOwen/roblox-testservice-watcher/releases/latest).

## See also

-   [TestEz](https://github.com/Roblox/testez), a unit testing framework for Roblox Studio
-   [luassert](https://github.com/Olivine-Labs/luassert), an assertion library (with spies) for Lua
