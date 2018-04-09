FROM alpine:edge

RUN apk add --no-cache haproxy ruby libevent libressl2.6-libcrypto libressl2.6-libssl zlib zstd xz-libs zstd-dev zlib-dev

RUN apk --update add --virtual build-dependencies ruby-bundler ruby-dev git build-base automake autoconf libevent-dev libressl-dev ruby-nokogiri  \
  && gem install --no-ri --no-rdoc socksify \
  && cd /tmp \
  && git clone https://github.com/torproject/tor.git \
  && cd tor \
  && ./autogen.sh \
  && ./configure --disable-asciidoc --enable-tor2web-mode \
  && make -j4 \
  && make install \
  && cd .. \
  && rm -rf tor \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*


ADD haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb

ADD start.rb /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/start.rb

EXPOSE 2090 8118 5566

CMD ruby /usr/local/bin/start.rb
