#!/bin/bash

source /usr/local/lib/entrypoint.sh

export BOLD_RED='\033[0;1;31m'
export YELLOW='\033[0;33m'
export NC='\033[0m'

export olcRootDN="$(grep "olcRootDN" "${SLAPD_CONFIG}/slapd.d/cn=config/olcDatabase={1}mdb.ldif" | awk '{print $2}')"
export olcSuffix="$(grep "olcSuffix" "${SLAPD_CONFIG}/slapd.d/cn=config/olcDatabase={1}mdb.ldif" | awk '{print $2}')"
export secret="${EP_SECRETS_ROOT}/ldap_admin_password"

# 1=user
function fail_if_admin()
{
	local cn="$(echo "${olcRootDN}" | sed --expression="s/^cn=\([^,]*\).*/\1/")"
	if [[ "${1,,}" == "${cn,,}" ]] ; then
		echo -e "This operation is not supported on: ${YELLOW}${olcRootDN}${NC}" >&2
		exit 1
	fi
}

function prompt_continue()
{
	read -p "Are you sure you want to continue? [y/N] " -r
	[[ ! "${REPLY}" =~ ^[Yy]$ ]] && exit 1
	return 0
}

function read_password()
{
	read -p "Generate a random password [Y/n] " -r
	if [[ "${REPLY}" =~ ^[Nn]$ ]] ; then
		read -p "New password:" -r -s PASSWORD 2>&1
	else
		export PASSWORD="$(pwgen --capitalize --numerals --secure -1 "${EP_PWGEN_LENGTH}")"
		echo -e "New password: ${BOLD_RED}${PASSWORD}${NC}"
	fi
	export PASSWORD_HASH="$(/usr/sbin/slappasswd -h "{SSHA}" -s "${PASSWORD}")"
}

