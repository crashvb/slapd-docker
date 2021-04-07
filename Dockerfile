FROM crashvb/supervisord:202103212252
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

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
