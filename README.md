# Docker Dynamic DNS for DynDNS

This is a very simple lightweight alpine/shell script mechanism for maintaining an up to date A record for a single host on DynDNS using the DynDNS checkip service.

# Usage

docker run -d \
	-e HOST=...Hostname to update...
	-e USERNAME=...DynDNS Username...
	-e APIKEY=...DynDNS API Key...

You may also include -e INTERVAL=XX where XX is the seconds between check/update cycles. 
You may also include -e RESOLVER=IP where IP is the IP address of the server you wish to use to check current DNS
