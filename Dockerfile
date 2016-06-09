FROM alpine:3.3

ENV SHELLDAP_VERSION 1.2.0
ENV SHELLDAP_SHA512 ee46a1aae146fe22e8530a41cc21ee35e4dfc1ae38cf77f43dc838dadaac36d3

RUN set -ex \
 && apk add --no-cache perl perl-yaml-syck perl-net-ldap perl-io-socket-ssl perl-authen-sasl perl-digest-md5 perl-term-readkey vim \
 && apk add --no-cache --virtual .build-deps perl-dev make ncurses-dev gcc musl-dev readline-dev \
 && echo y | cpan \
 && cpan Term::Shell Algorithm::Diff Term::ReadLine::Gnu \
 && runDeps="$( \
    scanelf --needed --nobanner --recursive /usr/local \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u \
  )" \
 && apk add --virtual .shelldap-rundeps $runDeps \
 && apk del .build-deps \
 && rm -rf ~/.cpan \
 && wget https://bitbucket.org/mahlon/shelldap/downloads/shelldap-${SHELLDAP_VERSION}.tar.gz \
 && echo "${SHELLDAP_SHA512}  shelldap-${SHELLDAP_VERSION}.tar.gz" | sha256sum -c - \
 && tar xzvf shelldap-${SHELLDAP_VERSION}.tar.gz \
 && mv shelldap-${SHELLDAP_VERSION}/shelldap /usr/local/bin \
 && rm -rf shelldap-${SHELLDAP_VERSION} shelldap-${SHELLDAP_VERSION}.tar.gz

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["shelldap"]
