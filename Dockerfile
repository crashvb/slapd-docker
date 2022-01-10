FROM crashvb/supervisord:202201080446@sha256:8fe6a411bea68df4b4c6c611db63c22f32c4a455254fa322f381d72340ea7226
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:8fe6a411bea68df4b4c6c611db63c22f32c4a455254fa322f381d72340ea7226" \
	org.opencontainers.image.base.name="crashvb/supervisord:202201080446" \
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
ENV SLAPD_HOME=/etc/ldap SLAPD_DIR=/var/lib/ldap
ADD ldap-* /usr/local/bin/
ADD ldaputils.sh /usr/local/lib/
ADD ldap /usr/local/share/ldap
RUN usermod --append --groups ssl-cert openldap && \
	chmod 0700 ${SLAPD_DIR}

# Configure: supervisor
ADD supervisord.slapd.conf /etc/supervisor/conf.d/slapd.conf

# Configure: entrypoint
ADD entrypoint.slapd /etc/entrypoint.d/10slapd

EXPOSE 389/tcp 636/tcp

VOLUME ${SLAPD_DIR} ${SLAPD_HOME}
