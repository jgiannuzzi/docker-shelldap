# vim:set ft=dockerfile:
FROM debian:jessie

RUN apt-get update && apt-get install -y --no-install-recommends shelldap vim && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["shelldap"]
