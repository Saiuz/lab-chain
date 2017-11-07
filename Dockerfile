FROM ubuntu:16.04

LABEL version="1.0"
LABEL maintainer="https://github.com/joesan"

ENV DEBIAN_FRONTEND noninteractive

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN \
  apt-get update && \
  apt-get -y install \
          software-properties-common \
          vim \
          pwgen \
          unzip \
          curl \
          git-core && \
  rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update && apt-get install -y geth

RUN adduser --disabled-login --gecos "" lab-chain-user

COPY common_init /home/lab-chain-user/lab-chain/common_init
RUN chown -R lab-chain-user:lab-chain-user /home/lab-chain-user/lab-chain/common_init
USER lab-chain-user
WORKDIR /home/lab-chain-user

RUN chmod u+x /home/lab-chain-user/lab-chain/common_init/*

RUN geth init lab-chain/common_init/lab-chain-genesis.json

ENTRYPOINT bash