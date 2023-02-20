Below is the mapping of Canasta versions to MediaWiki versions. Each Canasta version is built off of exactly one MediaWiki version.

| Canasta version | MediaWiki version |
| --- | --- |
| 1.0.x-1.1.0 | 1.35.6 |
| 1.1.1-1.1.2 | 1.35.7 |
| 1.2.0 | 1.35.8 |
| 1.3.0 | 1.39.1 |

## Concurrent support for MediaWiki 1.35 and 1.39
(The below plan has been ratified by the Benevolent Dictator.)

When MediaWiki 1.39 is released, several of Canasta's bundled extensions, including Semantic MediaWiki, are not expected to support 1.39. As a result, they will inevitably be unusable in versions of Canasta using MediaWiki 1.39 until the extension authors release patches to support them. This is not a limitation of Canasta and solely reflects the situation of the extension's incompatibility with MediaWiki 1.39. While Canasta will make every effort possible to release an update of Canasta that incorporates the updated extension as soon as the new version is released, in the meantime, Canasta will have no choice but to temporarily disable these extensions in Canasta versions built on 1.39.

We will continue supporting 1.2.x as the long-term support version for MediaWiki 1.35 until it is retired next year. We recommend sticking with Canasta 1.2.x until all of the extensions your wiki is using are confirmed to support MediaWiki 1.39.
