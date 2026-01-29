#!/bin/bash
# Fail2Ban Monitoring

echo "===== FAIL2BAN MONITOR ====="

fail2ban-client status sshd
fail2ban-client status postgresql
fail2ban-client status nginx-http-auth
fail2ban-client status laravel-scan
fail2ban-client status nginx-error
fail2ban-client status nginx-blocked
fail2ban-client status nginx-scanner
fail2ban-client status nginx-ratelimit
fail2ban-client status laravel-wordpress
fail2ban-client status phpmyadmin
fail2ban-client status recidive
fail2ban-client status nginx-ssl-handshake-protection
fail2ban-client status nginx-exchange-scan
fail2ban-client status convertor
grep Ban /var/log/fail2ban.log | tail -n 5
tail -n 10 /var/log/nginx/error.log
