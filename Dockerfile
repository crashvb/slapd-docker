FROM crashvb/supervisord:202302200210@sha256:7ad51ecd78041df68ff7800cbbb6ebd6c0b5644e1c8ff80bd55943710d2dd42d
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:7ad51ecd78041df68ff7800cbbb6ebd6c0b5644e1c8ff80bd55943710d2dd42d" \
	org.opencontainers.image.base.name="crashvb/supervisord:202302200210" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing slapd." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/slapd-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/slapd" \
	org.opencontainers.image.url="https://github.com/crashvb/slapd-docker"

# Install packages, download files ...
RUN docker-apt bc gnutls-bin ldap-utils slapd ssl-cert

# Configure: slapd
ENV SLAPD_CONFIG=/etc/ldap SLAPD_DIR=/var/lib/ldap
COPY ldap-* /usr/local/bin/
COPY ldaputils.sh /usr/local/lib/
COPY ldap /usr/local/share/ldap
RUN usermod --append --groups ssl-cert openldap && \
	chmod 0700 ${SLAPD_DIR} && \
	rm --force --recursive ${SLAPD_DIR:?}/*

# Configure: supervisor
COPY supervisord.slapd.conf /etc/supervisor/conf.d/slapd.conf

# Configure: entrypoint
COPY entrypoint.slapd /etc/entrypoint.d/10slapd

# Configure: healthcheck
COPY healthcheck.slapd /etc/healthcheck.d/slapd

EXPOSE 389/tcp 636/tcp

VOLUME ${SLAPD_DIR} ${SLAPD_CONFIG}
