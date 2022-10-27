# Frequently asked questions

## Why shouldn't we use the Canasta image's repo?

The stack repo, regardless of which type you choose (Docker Compose, Kubernetes, etc.), will clone the appropriate Docker *image*, which is pre-built for your convenience and will be pulled when you first start up Canasta. The source code could technically be used to build the Docker image, but that is really not necessary; that would be like building your own binary from source code instead of just downloading the binary provided to you by the developers.

## Why does Canasta use Apache instead of Nginx?

Canasta uses Apache because the Wikimedia Foundation uses Apache to run Wikipedia and its other projects. By sticking as close to the Wikimedia Foundation's technology stack as possible, we get the best chance at running MediaWiki without bugs and in a sustainably maintainable way.

## Does Canasta have a version that uses Nginx instead of Apache?

At the moment, the base Canasta image does not offer an Nginx flavor. However, anyone is welcome to make a derivative image of Canasta (instructions to do this are on another page) and replace Apache with Nginx as desired.
