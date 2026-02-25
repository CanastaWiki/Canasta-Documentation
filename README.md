# Canasta
Canasta is an all-in-one MediaWiki package for sysadmins that makes it easy to manage MediaWiki, add extensions, and load starter content and data structures.

The base of Canasta is the Canasta tech stack, a MediaWiki stack made for easy deployment of enterprise-ready MediaWiki on production environments.

For all technical help, see the [Canasta homepage](https://canasta.wiki/) (some of which uses content from the files in this repository), and the [Canasta technical documentation](https://docs.canasta.wiki/) (which is itself automatically generated from the files at the [Canasta-CLI repository](https://github.com/CanastaWiki/Canasta-CLI)).

# About Canasta
## History
Project Canasta was launched by Yaron Koren, head of WikiWorks. Project Canasta is intended to make
Enterprise MediaWiki administration easier, while bringing the full power of MediaWiki and its extensions to the table.

## What's behind the name?
Canasta means "basket" in Spanish, alluding to Canasta's full-featured stack being like a single basket, complete with all of the tools needed.

## Principles

Canasta is built on the following principles:

- **Beginner friendly**. Canasta should be easy for a sysadmin to set up and configure.
- **Ease of installation and upgradability**. Canasta bundles everything needed to run MediaWiki and updating MediaWiki is as simple as pulling a new version of Canasta.
- **Ease of maintainability**. Canasta takes care of all of the routine maintenance aspects of MediaWiki without any further installations needed.
- **Convenience**. Canasta should have enhancements to allow for an easy-to-use administration experience. For example, Canasta bundles commonly-used extensions and skins used in the Enterprise MediaWiki community. In the future, Canasta aims to add support for enhanced capabilities to manage a MediaWiki instance, such as a Canasta wiki manager.
- **As backwards compatible with vanilla MediaWiki as possible**. Canasta should support drag-and-drop of a “normal” MediaWiki installation’s LocalSettings.php configuration. Sysadmins should be able to make most customizations just as they would with a “normal” install of MediaWiki, without referring to Canasta-specific documentation.
- **Stability**. Canasta will use an “ltsrel” compatibility policy. It will be kept up-to-date with the latest Long Term Support versions of MediaWiki and ignore intermediate versions. Canasta will be updated for all LTS minor releases. Extensions will be tied to specific git commits and will be updated infrequently.
- **Open source**. Canasta and its source code are free to be used and modified by everyone.
- **Customizability**. Sysadmins can use as little or as much of Canasta as you want by choosing which features to enable in their LocalSettings.php.
- **Extensibility**. Canasta should support “after-market” customization of the Canasta image. Derivative images should be able to make any change they want to Canasta, including overriding its base functionality.
- **Ready for source control**. Storing configuration on source control is an excellent DevOps practice for many reasons, including the ease of separating functionality from configuration and data. Canasta is built with this in mind. Simply follow Canasta’s “stack” repo structure and you’ll be able to place your Canasta config into source control.

Canasta supports two orchestrators for managing the stack: Docker Compose (V2) and Kubernetes.
