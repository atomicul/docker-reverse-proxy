# Docker Reverse Proxy
HTTP reverse proxy to route traffic with respect to the URI prefix. Useful for exposing multiple
http services on a single port.

This can be useful in a network of containers, as docker compose does automatically for example,
to expose multiple http services under a single socket address (i.e. an ip-port pair).

## Usage
This docker container expects one command line argument per prefix mapped. Each argument
must be a whitespace separated pair in the form of `<prefix> <address>`. For example,
given the command: 
```
docker run -p 3000:80 ghcr.io/atomicul/docker-reverse-proxy:${IMAGE_VERSION} '/ http://host1' '/a/b/ http://host2'
```
The following forwarding happens:
* `http://localhost:3000/` -> `http://host1/`
* `http://localhost:3000/a/` -> `http://host1/a/`
* `http://localhost:3000/a/b/` -> `http://host2/`
* `http://localhost:3000/a/b/c/` -> `http://host2/c/`

You can find an example in `compose.yml`.

## Debugging & Tweaking
You can mount `/logs` to check logs.

You can tweak the server configuration by mounting `/config`. 
