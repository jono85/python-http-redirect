# python-http-redirect
Python based docker container that automatically redirects any requests to a configured target URL.
All types of HTTP methods are supported, and request path does not make a difference - only checking for the requested URL's server domain name.

## Configuration
Configuration is done through environmental variables, details in the table below

| Enviro variable | example/default | comment |
| --- | --- | --- |
| TZ | Europe/Dublin | Timezone configuration for the container (optional for logging) |
| THREADS_COUNT | 2 | amount of threads for Gunicorn server. Default set to 2, should be enough given the little work the server does. |
| REQUEST_TIMEOUT | 30 | request timeout after which the Gunicorn server will respond with an error to the request. Likely will never happen. |
| SERVER_PORT | 80 | TCP port the container will be listening on |
| USE_SELF_SIGNED_SSL | false | change to 'true' if you want the server to listen for HTTPS using a self signed cert that will be generated upon boot. |
| DEFAULT_REDIRECT | https://www.google.com/ | Any requests to a domain that's not configured will be redirected here. |
| REDIRECT_CONFIG | { "some.domain.com": "https://redirected.address.com/" } | a single json string containing Key:Value pairs - Key is the domain of the request, Value is the URL the request will be redirected to. |
