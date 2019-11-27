FROM debian:buster

ENV TIKA_VERSION 1.22
ENV TIKA_URL https://www-eu.apache.org/dist/tika/tika-server-$TIKA_VERSION.jar

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends --yes \
    default-jre-headless \
    wget \
    tesseract-ocr \
    tesseract-ocr-all \
    && apt-get clean -y

RUN wget -P /usr/share/java $TIKA_URL

RUN adduser --system --disabled-password tika

RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER tika

ENTRYPOINT java -jar /usr/share/java/tika-server-${TIKA_VERSION}.jar -h 0.0.0.0
