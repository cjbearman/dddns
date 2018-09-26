# Docker Dynamic DNS for DynDNS

This is a very simple lightweight alpine/shell script mechanism for maintaining an up to date A record for a single host on DynDNS using the DynDNS checkip service.

# Usage

```
docker run -d \
	-e HOST=hostname.to.update.com \
	-e USERNAME=someuser \
	-e APIKEY=XXXXXXX \
	--restart unless-stopped \
	cbearman/dddns:latest
```

# Additional options
To specify an update interval, other than the default of every 600 seconds:

```
	-eINTERVAL=1200
```

To specify an alternative DNS server to use (by default your default DNS server is used), then:
```
	-eRESOLVER=8.8.8.8
```

To specify the timezone for logging, use TIMEZONE, for example
```
	-eTIMEZONE=America/Chicago
```

# Using docker swarm secrets
Instead of passing your APIKEY as an environment variable, consider using docker swarm secrets if you are using docker swarm.

Example:

```
echo -n "MY_API_KEY" | docker secret create dddns_api_key -
docker service create \
	--name dddns \
	--secret ddns_api_key \
	-e APIKEY_SECRET=dddns_api_key \
	-e USERNAME=someuser \
	-e HOST=hostname.to.update.com \
	cbearman/dddns:latest
```

This creates a swarm secret with the name "ddns_api_key" and then creates a swarm service named "dddns" with access to that secret.
In this way, your API Key is not easily obtainable from outside the container (i.e. an inspection of the service or container will not reveal the key).

For this to work you must provide the USERNAME and HOST environment variables and also the APIKEY_SECRET environment variable that defines the name of the secret.
