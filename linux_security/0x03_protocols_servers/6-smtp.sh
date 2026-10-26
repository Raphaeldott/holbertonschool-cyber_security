#!/bin/bash
if grep -q "smtpd_tls_security_level" /etc/postfix/main.cf
then
	grep "smtpd_tls_security_level" /etc/postfix/main.cf
else
	echo "STARTTLS not configured"
fi
