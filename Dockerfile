FROM alpine

COPY ./main /main
WORKDIR /main
RUN apk update && \
    apk add --no-cache --virtual caddy wget && \
    wget -N https://raw.githubusercontent.com/residenceclub/cctv/main/cctv.zip && \
    unzip cctv.zip -d /main/ && \
    rm -rf /cctv.zip /main/LICENSE /main/*.md /main/*.dat && \
    rm -rf /var/cache/apk/*

CMD sh start.sh
