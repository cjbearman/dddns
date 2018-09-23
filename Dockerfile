FROM alpine:latest

RUN apk add bind-tools && \
    apk add curl && \
    apk add sed
ADD dddns.sh /dddns.sh

CMD [ "/bin/sh", "/dddns.sh" ]
