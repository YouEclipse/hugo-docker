FROM alpine:latest AS builder

LABEL maintainer=chuiyouwu@gmail.com


ENV HUGO_VERSION=0.66.0
ENV HUGO_EXTENDED=_extended


RUN apk add --update git asciidoctor libc6-compat libstdc++ \
    && apk upgrade \
    && apk add --no-cache ca-certificates

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo${HUGO_EXTENDED}_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp

RUN tar -xf /tmp/hugo${HUGO_EXTENDED}_${HUGO_VERSION}_Linux-64bit.tar.gz -C   /usr/local/bin/

#ENV CADDY_VERSION =v2.0.0-beta.15

ADD https://github.com/caddyserver/caddy/releases/download/v2.0.0-beta.15/caddy2_beta15_linux_amd64 /tmp 

RUN   mv /tmp/caddy2_beta15_linux_amd64 /tmp/caddy


ENV GIT_REPOSITORY=https://github.com/YouEclipse/blog.git
ENV GIT_REPOSITORY_NAME=blog

RUN apk --no-cache add git

WORKDIR /tmp

RUN git clone ${GIT_REPOSITORY}  

RUN cd ${GIT_REPOSITORY_NAME} \
    && hugo -D

FROM alpine:latest as runner


WORKDIR /tmp

COPY --from=0 /tmp/caddy /usr/bin/caddy

COPY --from=0 /tmp/blog/public ./public/

ADD Caddyfile .
ADD run.sh .

RUN chmod +x /usr/bin/caddy

CMD caddy run -config /tmp/Caddyfile --adapter caddyfile
 

EXPOSE 80
