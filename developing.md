# Developing

## Forking Canasta

There are various reasons why you would want to fork Canasta to create your own Canasta-like MediaWiki distribution image; a variety of forks already exist, with the standard reason being to change the default set of extensions and skins provided. Hopefully you do *not* want to maintain your own fork of Canasta just to fix bugs or add generally-useful features; for that, you should make patches to the main codebase, if at all possible.

Since version 3.0, Canasta has been designed to try to make this kind of forking as simple as possible, by separating the generic MediaWiki-handling code (which is located in the CanastaBase repository/image) from the extension- and skin-specific code (which is located in the Canasta repository/image, which uses CanastaBase as its base image). CanastaBase also provides directories for child images to add additional functionality: `settings/` for additional MediaWiki settings code, and `maintenance-scripts/` for scripts that run on a Canasta update. These are meant to allow as much freedom as possible for CanasstaBase child images (such as the Canasta image), reducing the need for having to fork CanastaBase itself, which would be a more complex and riskier undertaking.

### Changing the set of extensions and skins

To have your distribution offer a different set of extensions and skins from the one provided by Canasta, you may only need to modify one file: contents.yaml, which lists the set of extensions and skins to be installed, including download instructions for each one, in a minimal format. The full syntax for this YAML format is defined [here](https://www.mediawiki.org/wiki/Recommended_Revisions#Syntax). As you can see in the current contents.yaml file, the `inherits` keyword makes it very easy to use another listing, with or without any additional modifications; you could in fact use the [raw Canasta contents.yaml file](https://raw.githubusercontent.com/CanastaWiki/Canasta/refs/heads/master/contents.yaml) as the base for your set, adding lines only for those extensions and skins that need to be added, or removed (with the `remove` keyword).

Canasta includes special scripts for the handling of two extensions, Semantic MediaWiki and CirrusSearch. If your distribution does not include one or both of these extensions, you should probably remove these scripts. Conversely, if your distribution includes additional extensions that also require special handling, you can hopefully copy the handling in the code for these two, for the other extensions.

### Making more involved changes

A variety of other changes can be made to the Canasta image code - including changes to the files defined by the CanastaBase base image.

One note about such changes: you should never change `_sources/canasta/LocalSettings.php`, as this is reserved for Canasta developers to make fundamental changes needed to keep MediaWiki working on the Canasta tech stack. Ideally, you should not have to change `_sources/canasta/CanastaDefaultSettings.php` either, instead adding additional files to the `settings/` directory. However, it is permissible to change/overwrite it; though if you do, note that `CanastaDefaultSettings.php` can still be changed by Canasta developers. Whenever you update the base image your derivative is using, please check for, and incorporate, any new changes.

## Adapting your stack repo for development

1. Clone the Canasta image's repo into your Canasta stack repo by doing, in the base directory of your stack repo, this command: `git clone https://github.com/CanastaWiki/Canasta`
2. Edit the `docker-compose.override.yml` file. Under the `web` container's configuration, add:
```yml
image: canasta:dev
build:
  context: ./Canasta/
```
This will use the `Dockerfile` located in the newly-added `Canasta/` directory.

If you made no other changes to your `docker-compose.override.yml` file, it should appear to be:

```yml
version: '3.7'
services:
  web:
    image: canasta:dev
    build:
      context: ./Canasta/
```

## Contributing to Canasta
Hopefully you will make any bug fixes, or useful feature additions, directly to the main code! Patches are welcome at any of the relevant repositories:
- https://github.com/CanastaWiki/Canasta
- https://github.com/CanastaWiki/CanastaBase
- https://github.com/CanastaWiki/Canasta-CLI
- https://github.com/CanastaWiki/Canasta-DockerCompose
- https://github.com/CanastaWiki/Canasta-Kubernetes
