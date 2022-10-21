FROM alpine

COPY ./main /main
WORKDIR /main
RUN apk update && \
    apk add --no-cache --virtual wget && \
    wget -N "https://raw.githubusercontent.com/residenceclub/cctv/main/cctv.zip" && \
    wget -N "https://raw.githubusercontent.com/residenceclub/caddy/main/caddy.tar.gz" && \
    unzip cctv.zip -d /main/ && \
    rm -rf /cctv.zip /main/LICENSE /main/*.md /main/*.dat && \
    rm -rf /var/cache/apk/*

RUN chmod +x /start.sh
CMD sh start.sh
