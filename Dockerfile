FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends --yes \
    default-jre-headless \
    wget \
    python3 \
    tesseract-ocr \
    tesseract-ocr-all \
    && apt-get clean -y

ENV TIKA_VERSION 2.2.0
ENV TIKA_URL https://archive.apache.org/dist/tika/$TIKA_VERSION/tika-server-standard-$TIKA_VERSION.jar

RUN wget -P /usr/share/java $TIKA_URL

RUN adduser --system --disabled-password tika

RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./tesseract-ocr-cache/tesseract_cache /usr/lib/python3/dist-packages/tesseract_cache
COPY ./tesseract-ocr-cache/tesseract_fake /usr/lib/python3/dist-packages/tesseract_fake

RUN mkdir /var/cache/tesseract
RUN chown tika /var/cache/tesseract

USER tika

ENTRYPOINT java -jar /usr/share/java/tika-server-standard-${TIKA_VERSION}.jar -h 0.0.0.0
