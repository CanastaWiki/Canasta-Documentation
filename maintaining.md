# Maintaining your wiki

## Running maintenance scripts
MediaWiki contains over 200 [maintenance scripts](https://www.mediawiki.org/wiki/Manual:Maintenance_scripts) in its `maintenance\` directory; you can see the full list [here](https://www.mediawiki.org/wiki/Manual:Maintenance_scripts/List_of_scripts).
These scripts cover everything from actions like changing users' passwords and importing a batch of images, to much more obscure tasks like testing the MediaWiki parser.

There is a reasonable chance that you will never need to run a maintenance script while using Canasta. The most important maintenance script is `update.php`, but it is run during the container startup process, so if you need to run it, you can always get it to run simply by calling the `canasta restart` command.
As for `runJobs.php`, another popular maintenance script, the job queue is always automatically run during the entire life of the container.

However, in case you do want to run a MediaWiki maintenance script, you can call the following:

```bash
sudo canasta maintenance "SCRIPT_NAME.php"
```

The quotation marks are there so that you can pass in flags to the script, and not have the `canasta maintenance` command think that these are its own flags. For instance, to create a new "WikiSysop" administrator account, with password "VerySecurePassw0rd", you could call the following:

```bash
sudo canasta maintenance "createAndPromote.php WikiSysop VerySecurePassw0rd --bureaucrat --sysop"
```
