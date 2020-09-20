# Example of Kong with API Key Authentication

In this repo we supply scripts to bring up Kong with 10,000 API keys loaded into an in-memory database.

## Usage

Bring up Kong:
```
docker-compose up
```

Observe (via Mockbin) an authenticated request's headers being passed upstream, including the email address associated with the API key in the `x-consumer-username` header (the API key below is randomly selected from `kong_konfig.yml`):

```
$ curl -s http://localhost:8000/api?apikey=VMqTCtprQhrmUm8DpPlBLQGXiBJ2lTyU
{
  "startedDateTime": "2020-09-20T16:51:18.402Z",
  "clientIPAddress": "172.27.0.1",
  "method": "GET",
  "url": "http://localhost/request?apikey=VMqTCtprQhrmUm8DpPlBLQGXiBJ2lTyU",
  "httpVersion": "HTTP/1.1",
  "cookies": {},
  "headers": {
    "host": "mockbin.org",
    "connection": "close",
    "x-forwarded-for": "[redacted]",
    "x-forwarded-proto": "http",
    "x-forwarded-host": "localhost",
    "x-forwarded-port": "80",
    "x-real-ip": "[redacted]",
    "x-forwarded-prefix": "/api",
    "user-agent": "curl/7.71.1",
    "accept": "*/*",
    "x-consumer-id": "86258d90-9f30-59db-9315-ac9c81b9f69e",
    "x-consumer-username": "8RLyBZZmxfLHh1rOgbkRs7aXgTVcYWT2@example.com",
    "x-credential-identifier": "2b59891e-b067-524c-b9d0-74c2b5d305fe",
    "x-request-id": "2b0daeb3-12e9-4aa2-9616-f9e350007b7d",
    "via": "1.1 vegur",
    "connect-time": "0",
    "x-request-start": "1600620678395",
    "total-route-time": "0"
  },
  "queryString": {
    "apikey": "VMqTCtprQhrmUm8DpPlBLQGXiBJ2lTyU"
  },
  "postData": {
    "mimeType": "application/octet-stream",
    "text": "",
    "params": []
  },
  "headersSize": 662,
  "bodySize": 0
}

```

In the case where no API key is supplied, we see `anonymous-user` in the aforementioned header:

```
$ curl -s http://localhost:8000/api
{
  "startedDateTime": "2020-09-20T16:49:29.184Z",
  "clientIPAddress": "172.27.0.1",
  "method": "GET",
  "url": "http://localhost/request",
  "httpVersion": "HTTP/1.1",
  "cookies": {},
  "headers": {
    "host": "mockbin.org",
    "connection": "close",
    "x-forwarded-for": "[redacted]",
    "x-forwarded-proto": "http",
    "x-forwarded-host": "localhost",
    "x-forwarded-port": "80",
    "x-real-ip": "[redacted]",
    "x-forwarded-prefix": "/api",
    "user-agent": "curl/7.71.1",
    "accept": "*/*",
    "x-consumer-id": "5e2b545b-f71b-50c7-9afa-b2bf20dba80b",
    "x-consumer-username": "anonymous-user",
    "x-anonymous-consumer": "true",
    "x-request-id": "408999c8-67f0-4a0c-929f-5476288adcf4",
    "via": "1.1 vegur",
    "connect-time": "1",
    "x-request-start": "1600620569177",
    "total-route-time": "0"
  },
  "queryString": {},
  "postData": {
    "mimeType": "application/octet-stream",
    "text": "",
    "params": []
  },
  "headersSize": 559,
  "bodySize": 0
}
```

If we didn't want to allow anonymous authentication, we would remove `config.anonymous` from `kong_config.yml`.

## Key regeneration
Running `keygen.sh` will (slowly) yield you `keys.csv`. You can then run `map_keys_to_kong_yaml.sh` which reads `keys.csv` and outputs `consumers.yml`. The contents of the latter should be copy and pasted into `kong_config.yml`.

It is important to note that if you want to be able to use the Kong API to drip-feed new API keys into a running instance, Kong seems (at the time of writing, 2020-09-20) to require a real database.