FROM ubuntu:latest
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y curl fish libasound2

ENV NIGHTLY_VERSION=2022-12-03-012810d
ENV DOWNLOAD_FILE=roc_nightly-linux_x86_64-${NIGHTLY_VERSION}.tar.gz

RUN curl -OL https://github.com/roc-lang/roc/releases/download/nightly/${DOWNLOAD_FILE} \
  && tar -xzf ${DOWNLOAD_FILE} \
  && rm ${DOWNLOAD_FILE} \
  && mv roc /usr/local/bin/roc

RUN mkdir /app
WORKDIR /app

CMD fish
