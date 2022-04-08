# Developing

## Adapting your stack repo for development

1. Clone the Canasta image's repo into your Canasta stack repo by doing, in the base directory of your stack repo, this command: `git clone https://github.com/CanastaWiki/Canasta`
2. Under the `web` container's configuration, change:
```
image: ghcr.io/canastawiki/canasta:latest
```
to
```
build:
  context: ./Canasta/
```
This will use the `Dockerfile` located in the newly-added `Canasta/` directory.

## Making a derivative image

Canasta supports creating derivative images using your own `Dockerfile` when done in the officially supported way.

Rather than forking the Canasta image's repo and modifying its Dockerfile, the correct way to make a derivative image is by creating your own Dockerfile whose base image is the Canasta image. The directives on your Dockerfile therefore is quite concise, clean, and only contain changes made to Canasta.

You can change `_sources/canasta/CanastaDefaultSettings.php` however you want, but you should never change `_sources/canasta/LocalSettings.php`, as this is reserved for Canasta developers to make fundamental changes needed to keep MediaWiki working on the Canasta tech stack.

Keep in mind:

- Derivative images are officially supported by Canasta, but only if these requirements are followed.
- `CanastaDefaultSettings.php` will still be changed by Canasta developers. Whenever you update the base image your derivative is using, it is your responsibility to incorporate new changes to it.

## Contributing to Canasta
If you want to contribute changes to base Canasta rather than simply making a change in a derivative image, you can make changes to the Canasta image at https://github.com/CanastaWiki/Canasta.
