FROM alpine:3.11
MAINTAINER Daniel Schwemmlein (dan@linuxhelp.today)

ENV CLAMD_DEPS \
        git \
        linux-headers
RUN set -x \
    && apk add --no-cache --virtual .persistent-deps \
        bash \
        coreutils \
        wget \
        findutils \
        perl \
        curl \
        clamav-daemon \
        clamav-libunrar \
        monit \
    && apk add --no-cache --virtual .build-deps \
        $CLAMD_DEPS \
    && chmod +x /usr/bin/ \
    && mkdir -p /var/lib/clamav \
    && mkdir /opt \
    && mkdir /home \
    && mkdir /tmp \
    && apk del .build-deps

COPY usr/bin/crond.sh /usr/bin/cron
COPY usr/bin/clamd.sh /usr/bin/clam
COPY etc/ /etc/
COPY tests/ /tests/
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod -R +x /docker-entrypoint.sh /usr/local/bin /usr/bin /tests

EXPOSE 3310

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/clamd", "-c", "/etc/clamd.conf"]
