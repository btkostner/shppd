# Running

You can run Shppd via Docker. Running the basic image can be done via:

```sh
docker run \
    --env DATABASE_PATH=/database.sql \
    --env HOST=localhost \
    --env PORT=4000 \
    --env SECRET_KEY_BASE=$(openssl rand -hex 64) \
    --publish 4000:4000 \
    ghcr.io/btkostner/shppd:latest
```

However, you'll want to modify this command to include some more environment variables.

| Environment Variable | Description | Default |
| --- | --- | --- |
| `DATABASE_PATH` | The path to the SQLite database file. |  |
| `DNS_CLUSTER_QUERY` | The DNS query to use for cluster discovery. |  |
| `HOST` | The domain to use for generating links. | "example.com" |
| `POOL_SIZE` | The number of database connections to keep open. | 5 |
| `PORT` | The port to run the server on. | 4000 |
| `SECRET_KEY_BASE` | The encryption key for http secrets. |  |

## DATABASE_PATH

The `DATABASE_PATH` environment variable is the path to the SQLite database file. This is where all of the data is stored. If you don't specify this, the database will be stored in the container and will be lost when the server is stopped.

## DNS_CLUSTER_QUERY

The `DNS_CLUSTER_QUERY` environment variable is the DNS query to use for cluster discovery. This is used to find other Shppd servers to connect to. If you don't specify this, the server will not be clustered.

Provided by [dns_cluster](https://github.com/phoenixframework/dns_cluster) library.

## HOST

The `HOST` environment variable is the domain to use for generating links. This is used to generate full URL links in emails and other places. If you don't specify this, the domain will be "example.com" which may provide incorrect links.

## POOL_SIZE

The `POOL_SIZE` environment variable is the number of database connections to keep open. More connections will allow more concurrent requests, but will use more memory. If you don't specify this, the pool size will be 5.

## PORT

The `PORT` environment variable is the port to run the server on. This is the port that the server will listen on for incoming requests. If you don't specify this, the server will run on port 4000.

## SECRET_KEY_BASE

The `SECRET_KEY_BASE` environment variable is the encryption key for http secrets. This is used to encrypt and decrypt cookies and other data. This needs to be a 64 character random string.
