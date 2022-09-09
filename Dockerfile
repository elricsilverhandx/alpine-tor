FROM alpine:edge

RUN apk add --no-cache tor haproxy ruby libevent libressl-dev zlib zstd xz-libs zstd-dev zlib-dev && \
  gem install --no-document socksify

ADD haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb

ADD start.rb /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/start.rb

EXPOSE 2090 8118 5566

CMD ruby /usr/local/bin/start.rb
