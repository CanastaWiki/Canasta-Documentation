## Enabling extensions and skins
A Canasta installation contains 163 extensions and 10 skins, all chosen for the functionality and display they add to MediaWiki; see [Contents](https://canasta.wiki/contents/#extensions-included-in-canasta) for the complete listing. By default, only one of these (the "Vector" skin) is enabled on Canasta; any of the rest must be manually enabled. For any extension or skin, there are two main ways to enable it:

- Add a line to enable it to any file in the config/settings/global/ or config/settings/wikis/_YourWikiID_/ directory, depending on whether you want all the wikis in this installation to contain this extension/skin, or just one. (For Canasta installations containing just one wiki, it doesn't matter which you do.) The line should be a simple call to either `wfLoadExtension()` or `wfLoadSkin()`; for example:

  `wfLoadExtension( 'VisualEditor' );`

- Call the command [`canasta extension enable`](https://canastawiki.github.io/Canasta-CLI/cli/canasta_extension_enable/) or [`canasta skin enable`](https://canastawiki.github.io/Canasta-CLI/cli/canasta_skin_enable/), which in turn adds a new short file to either the config/settings/global/ or the config/settings/wikis directory, depending on how it is called. These can then be undone by removing the short file manually, or by calling one of the corresponding commands [`canasta extension disable`](https://canastawiki.github.io/Canasta-CLI/cli/canasta_extension_disable/) and [`canasta skin disable`](https://canastawiki.github.io/Canasta-CLI/cli/canasta_skin_disable/).

In either case, there is the chance that an extension or skin you enable will require a database update to work, because it defines its own DB tables that must be created. The easiest way to do such a database update is to simply call  [`canasta restart`](https://canastawiki.github.io/Canasta-CLI/cli/canasta_restart/) after you have enabled one or more additional extensions or skins.

## Installing additional extensions and skins
There are of course hundreds of other extensions and skins that you might want to add to any specific Canasta installation. You may even have some custom=developed extensions or skins that you want to use. Or there might even be extensions or skins already included in Canasta, but for which you want to use a different version (older or newer) than what Canasta holds. For all three of these cases, the process is the same: add the directory containing the code for that extension or skin to your Canasta installation's extensions/ or skins/ directory "enable" it using one of the two options liste above, and then call `canasta restart`.

The `canasta restart` command will accomplish up to three things: let Canasta know about this new code directory run a Composer call to download any library dependencies that this extenions or skin may have (as specified in its composer.json file), and update the database, in case the extension or skin defines its own database tables.
