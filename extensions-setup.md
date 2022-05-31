# Extensions setup
Canasta bundles over 100 extensions and skins to make life easy for you. However, Canasta remains neutral and doesn't require you/"voluntell" you to install any certain skin or extension. Therefore, you still need to add some lines to `LocalSettings.php` to set up the wiki with the extensions you want. (In the future, a command-line interface will be made available to facilitate this.)

## 1. A very simple starting point
There are a few major "revolutionary" extensions that add significant functionality to MediaWiki and that virtually all wikis should be using. Along with a skin of choice, this mini-guide walks you through how to set up the following:

- Vector
- VisualEditor
- CirrusSearch (and Elastica and AdvancedSearch)

### Quick setup of revolutionary extensions

1. Add the following into `LocalSettings.php`:

```php
$wgDefaultSkin = 'vector';

cfLoadExtension( 'VisualEditor' );

cfLoadExtension( 'Elastica' );
cfLoadExtension( 'CirrusSearch' );
cfLoadExtension( 'AdvancedSearch' );

$wgSearchType = 'CirrusSearch';
$wgCirrusSearchServers = [ 'elasticsearch' ];
```

2. Run the following from your Canasta stack directory (the one you downloaded from `Canasta-DockerCompose`):

```bash
sudo docker-compose exec web php /var/www/mediawiki/w/canasta-extensions/CirrusSearch/maintenance/UpdateSearchIndexConfig.php \
&& sudo docker-compose exec web php /var/www/mediawiki/w/canasta-extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipLinks --indexOnSkip \
&& sudo docker-compose exec web php /var/www/mediawiki/w/canasta-extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipParse
```

This code initializes the Elasticsearch container to run CirrusSearch.

3. Done! You can now use VisualEditor and CirrusSearch.

## 2. Adding very popular extensions
There are a larger number of extensions, most of which are already bundled with vanilla MediaWiki, that almost all wikis will want to install.

1. Copy and paste this into your `LocalSettings.php` file to enable them:

```php
cfLoadExtension( 'Cite' );
cfLoadExtension( 'CiteThisPage' );
cfLoadExtension( 'CodeEditor' );
cfLoadExtension( 'ConfirmEdit' );
cfLoadExtension( 'Gadgets' );
cfLoadExtension( 'ImageMap' );
cfLoadExtension( 'InputBox' );
cfLoadExtension( 'Interwiki' );
cfLoadExtension( 'MobileFrontend' );
cfLoadExtension( 'MultimediaViewer' );
cfLoadExtension( 'Nuke' );
cfLoadExtension( 'OATHAuth' );
cfLoadExtension( 'PageImages' );
cfLoadExtension( 'ParserFunctions' );
cfLoadExtension( 'PdfHandler' );
cfLoadExtension( 'Poem' );
cfLoadExtension( 'Renameuser' );
cfLoadExtension( 'ReplaceText' );
cfLoadExtension( 'Scribunto' );
cfLoadExtension( 'SecureLinkFixer' );
cfLoadExtension( 'SpamBlacklist' );
cfLoadExtension( 'TemplateData' );
cfLoadExtension( 'TextExtracts' );
cfLoadExtension( 'TitleBlacklist' );
cfLoadExtension( 'WikiEditor' );

cfLoadSkin( 'MinervaNeue' );

$wgMFDefaultSkinClass = 'SkinMinerva';
```

Note that this block of `cfLoadExtension`s doesn't include VisualEditor or CirrusSearch because they were already installed in the preceding section.

2. Restart Canasta. This is necessary for login to work (since OATHAuth creates new database tables). Use this one-liner:

```bash
sudo docker-compose down && sudo docker-compose up -d
```

3. Done! Now, you can immediately use all of these extensions.

## 3. More extensions
You can always install more extensions using the list provided at [canasta.wiki/documentation/#extensions-included-in-canasta](https://canasta.wiki/documentation/#extensions-included-in-canasta).
