# Frequently asked questions

## Why shouldn't we use the Canasta image repositories?

Regardless of what stack you use (Docker Compose, Kubernetes, etc.), downloading Canasta will clone the appropriate Docker *images* (for CanastaBase and Canasta), which are pre-built, not the original code repositories. The source code for these Docker images could technically be used to build them locally, but there is no benefit to doing that - unless you are planning to do development on that code.

## Why does Canasta use Apache instead of Nginx?

Canasta (really, CanastaBase) uses Apache because the Wikimedia Foundation uses Apache to run Wikipedia and its other projects. Sticking as close to the Wikimedia Foundation's technology stack as possible gives the best chance of running MediaWiki without bugs, now and in the future.

## Does Canasta have a version that uses Nginx instead of Apache?

At the moment, the CanastaBase image does not offer an Nginx flavor. However, anyone is welcome to make a derivative image of Canasta (instructions to do this are on another page) and replace Apache with Nginx as desired.
