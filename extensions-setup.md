# Extensions setup
Canasta bundles over 100 extensions and skins to make life easy for you. However, Canasta remains neutral and doesn't require you/"voluntell" you to install any certain skin or extension. Therefore, you still need to add some lines to `LocalSettings.php` to set up the wiki with the extensions you want. (In the future, a command-line interface will be made available to facilitate this.)

## 1. A very simple starting point
There are a few major "must have" extensions that add significant functionality to MediaWiki and that virtually all wikis should be using. Along with a skin of choice, this mini-guide walks you through how to set up the following:

- Vector
- VisualEditor
- CirrusSearch (and Elastica and AdvancedSearch)

### Quick setup of must have extensions

1. Add the following into `LocalSettings.php`:

```php
$wgDefaultSkin = 'vector'; // wfLoadSkin( 'Vector' ); is present in config/settings/Vector.php

wfLoadExtension( 'VisualEditor' );

wfLoadExtension( 'Elastica' );
wfLoadExtension( 'CirrusSearch' );
wfLoadExtension( 'AdvancedSearch' );

$wgSearchType = 'CirrusSearch';
$wgCirrusSearchServers = [ 'elasticsearch' ];
```

2. Run the following from your Canasta stack directory (the one you downloaded from `Canasta-DockerCompose`):

```bash
sudo docker compose exec web php /var/www/mediawiki/w/canasta-extensions/CirrusSearch/maintenance/UpdateSearchIndexConfig.php \
&& sudo docker compose exec web php /var/www/mediawiki/w/canasta-extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipLinks --indexOnSkip \
&& sudo docker compose exec web php /var/www/mediawiki/w/canasta-extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipParse
```

This code initializes the Elasticsearch container to run CirrusSearch.

3. Done! You can now use VisualEditor and CirrusSearch.

## 2. Adding very popular extensions
There are a larger number of extensions, most of which are already bundled with vanilla MediaWiki, that almost all wikis will want to install.

1. Copy and paste this into your `LocalSettings.php` file to enable them:

```php
wfLoadExtension( 'Cite' );
wfLoadExtension( 'CiteThisPage' );
wfLoadExtension( 'CodeEditor' );
wfLoadExtension( 'ConfirmEdit' );
wfLoadExtension( 'Gadgets' );
wfLoadExtension( 'ImageMap' );
wfLoadExtension( 'InputBox' );
wfLoadExtension( 'Interwiki' );
wfLoadExtension( 'MobileFrontend' );
wfLoadExtension( 'MultimediaViewer' );
wfLoadExtension( 'Nuke' );
wfLoadExtension( 'OATHAuth' );
wfLoadExtension( 'PageImages' );
wfLoadExtension( 'ParserFunctions' );
wfLoadExtension( 'PdfHandler' );
wfLoadExtension( 'Poem' );
wfLoadExtension( 'Renameuser' );
wfLoadExtension( 'ReplaceText' );
wfLoadExtension( 'Scribunto' );
wfLoadExtension( 'SecureLinkFixer' );
wfLoadExtension( 'SpamBlacklist' );
wfLoadExtension( 'TemplateData' );
wfLoadExtension( 'TextExtracts' );
wfLoadExtension( 'TitleBlacklist' );
wfLoadExtension( 'WikiEditor' );

wfLoadSkin( 'MinervaNeue' );

$wgMFDefaultSkinClass = 'SkinMinerva';
```

Note that this block of `wfLoadExtension`s doesn't include VisualEditor or CirrusSearch because they were already installed in the preceding section.

2. Restart Canasta. This is necessary for login to work (since OATHAuth creates new database tables). Use this one-liner:

```bash
sudo docker compose down && sudo docker compose up -d
```

3. Done! Now, you can immediately use all of these extensions.

## 3. More extensions
You can always install more extensions using the list provided at <https://canasta.wiki/contents/#extensions-included-in-canasta>.
