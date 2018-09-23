# Docker Dynamic DNS for DynDNS

This is a very simple lightweight alpine/shell script mechanism for maintaining an up to date A record for a single host on DynDNS using the DynDNS checkip service.

# Usage

```
docker run -d \
	-e HOST=...Hostname to update...
	-e USERNAME=...DynDNS Username...
	-e APIKEY=...DynDNS API Key...
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