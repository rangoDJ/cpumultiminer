FROM alpine:3.4

RUN set -x \
 && apk add --no-cache libcurl libgcc libstdc++ openssl \
 && apk add --no-cache -t .build-deps autoconf automake build-base curl curl-dev git openssl-dev \
 && git clone --recursive https://github.com/tpruvot/cpuminer-multi.git /tmp/cpuminer \
 && cd /tmp/cpuminer \
 && ./autogen.sh \
 && ./configure CFLAGS="-O2 -march=native" --with-crypto --with-curl \
 && make install \
 && apk del --purge .build-deps \
 && rm -rf /tmp/* \
 && cpuminer --cputest \
 && cpuminer --version \
 && mkdir /cpuminer /cpuminer/config \
 && mv /usr/local/bin/cpuminer /cpuminer/cpuminer

WORKDIR /cpuminer

COPY script.sh /cpuminer/script.sh

RUN chmod +x /cpuminer/script.sh 

VOLUME /cpuminer

COPY config.json.sample /cpuminer/config/config.json.sample

ENTRYPOINT /cpuminer/script.sh
