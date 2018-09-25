FROM alpine:3.8

RUN apk add bind-tools && \
    apk add curl && \
    apk add sed && \
    apk add tzdata
ADD dddns.sh /dddns.sh

CMD [ "/bin/sh", "/dddns.sh" ]
