alpine-tor
==================

```
               Docker Container
               -------------------------------------
                        <-> Tor Proxy 1
Client <---->   HAproxy <-> Tor Proxy 2
                        <-> Tor Proxy n
```

Parents
-------

* [rdsubhas/docker-tor-privoxy-alpine](https://github.com/rdsubhas/docker-tor-privoxy-alpine)
* [Negashev/docker-haproxy-tor](https://github.com/Negashev/docker-haproxy-tor)
    * [marcelmaatkamp/docker-alpine-tor](https://github.com/marcelmaatkamp/docker-alpine-tor)
    * [mattes/rotating-proxy](https://github.com/mattes/rotating-proxy)

__Why:__ Lots of IP addresses. One single endpoint for your client.
Load-balancing by HAproxy.

Environment Variables
-----

* `tors` - Integer, number of tor instances to run. (Default: 20)
* `new_circuit_period` - Integer, NewCircuitPeriod parameter value in seconds.
  (Default: 2 minutes)
* `max_circuit_dirtiness` - Integer, MaxCircuitDirtiness parameter value in
  seconds. (Default: 10 minutes)
* `circuit_build_timeout` - Integer, CircuitBuildTimeout parameter value in
  seconds. (Default: 60 seconds)
* `haproxy_port_http` - Integer, port for http tunneling. (Default: 8118)
* `haproxy_port_socks` - Integer, port for haproxy. (Default: 5566)
* `haproxy_stats` - Integer, port for haproxy monitor. (Default: 2090)
* `haproxy_login` and `haproxy_pass` - BasicAuth config for haproxy monitor.
  (Default: `admin` in both variables)

Usage
-----

```bash
# build docker container
docker build -t zeta0/alpine-tor:latest .

# ... or pull docker container
docker pull zeta0/alpine-tor:latest

# start docker container
docker run -d -p 5566:5566 -p 2090:2090 -e tors=25 zeta0/alpine-tor

# test with ...
curl --socks5-hostname localhost:5566 http://httpbin.org/ip

# or with http
curl --proxy localhost:8118 http://httpbin.org/ip

# or to run chromium with your new found proxy
chromium --proxy-server="http://localhost:8118" \
    --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost"

# monitor
# auth login:admin
# auth pass:admin
http://localhost:2090 or http://admin:admin@localhost:2090

# start docket container with new auth
docker run -d -p 5566:5566 -p 2090:2090 -e haproxy_login=MySecureLogin \
    -e haproxy_pass=MySecurePassword zeta0/alpine-tor
```

Further Readings
----------------

* [Tor Manual](https://www.torproject.org/docs/tor-manual.html.en)
* [Tor Control](https://www.thesprawl.org/research/tor-control-protocol/)
* [HAProxy Manual](http://cbonte.github.io/haproxy-dconv/index.html)
