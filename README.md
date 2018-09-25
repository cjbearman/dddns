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
