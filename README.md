[![Hitsukaya](https://img.shields.io/badge/Hitsukaya-red)](https://hitsukaya.com)
[![Fail2Ban](https://img.shields.io/badge/Fail2Ban-protected-brightgreen)](https://www.fail2ban.org/)
[![Nginx](https://img.shields.io/badge/Nginx-webserver-blue)](https://nginx.org/)

# Laravel & WordPress Fail2Ban Filter

A **Fail2Ban filter** to protect Laravel, WordPress, and Node.js frameworks (Next.js/Nuxt) applications from common attacks, automated scans, and unauthorized access to sensitive files.

---

# Fail2Ban Filters for Laravel, WordPress and Node.js Frameworks

This repository provides a collection of Fail2Ban filters intended to protect web applications and services running on Nginx, SSH, PostgreSQL, and common PHP / Node.js frameworks such as Laravel, WordPress, Next.js, and Nuxt.js.

The filters focus on detecting automated scans, brute-force attempts, access to sensitive files, and repeated malicious behavior.

---

## Why it matters

Combining Nginx, Fail2Ban, firewall rules, and SELinux provides a multi-layered security approach:

- **Nginx**: Handles all incoming HTTP/HTTPS requests and can reject invalid requests immediately.  
- **Fail2Ban**: Monitors logs for suspicious activity and blocks IPs temporarily or permanently.  
- **Firewall (iptables, firewalld, nftables, etc.)**: Prevents unwanted traffic from reaching your server.  
- **SELinux / AppArmor**: Restricts what processes can do on the system, limiting the impact of potential breaches.  

Together, these layers reduce the attack surface, mitigate brute-force attempts, and protect sensitive files while maintaining server stability.

---

## Supported Platforms & Services

| Service / Stack | Supported |
|-----------------|-----------|
| Nginx           | ✅ |
| Laravel         | ✅ |
| WordPress       | ✅ |
| Next.js         | ✅ |
| Nuxt.js         | ✅ |
| Generic Node.js | ✅ |
| SSH (OpenSSH)   | ✅ |
| PostgreSQL      | ✅ |
| phpMyAdmin      | ✅ |

---

## Filter Overview

### Web Application & Nginx Filters

| Filter name | Purpose | Typical log |
|------------|--------|-------------|
| `laravel-scan` | Blocks access to Laravel, Node.js, WordPress sensitive files | `nginx/access.log` |
| `nginx-scanner` | Detects generic web scanners and automated probes | `nginx/access.log` |
| `nginx-ratelimit` | Detects excessive HTTP requests | `nginx/access.log` |
| `nginx-blocked` | Detects requests blocked with HTTP 444 | `nginx/access.log` |
| `nginx-http-auth` | Detects failed HTTP basic authentication | `nginx/error.log` |

---

### Sensitive File & Path Protection (Examples)

These filters detect requests for:

- `.env`
- `.git/`
- `.htaccess`, `.htpasswd`
- `artisan`
- `storage/`, `vendor/`, `config/`, `bootstrap/`
- `package.json`, `package-lock.json`, `yarn.lock`
- `next.config.js`, `nuxt.config.js`
- `Dockerfile`, `docker-compose.yml`
- Backup files (`.bak`, `.old`, `/backup/`)
- WordPress paths (`wp-admin`, `wp-login.php`, `xmlrpc.php`)

---

### System & Service Protection

| Filter name | Purpose | Typical log |
|------------|--------|-------------|
| `sshd` | Protects OpenSSH from brute-force and scanning | systemd journal |
| `postgresql` | Detects failed PostgreSQL authentication attempts | PostgreSQL logs |
| `phpmyadmin` | Detects unauthorized phpMyAdmin access attempts | Nginx logs |
| `recidive` | Long-term ban for repeat offenders | Fail2Ban log |

---

## Recommended Jail Configuration

### Example: Laravel / Web Scan Protection

```bash
[laravel-scan]
enabled  = true
filter   = laravel-scan
logpath  = /var/log/nginx/access.log
maxretry = 3
bantime  = 1h
findtime = 10m
````
## Example: Nginx HTTP Auth Protection

```bash
[nginx-http-auth]
enabled  = true
filter   = nginx-http-auth
logpath  = /var/log/nginx/error.log
maxretry = 5
bantime  = 1h
````

## Example: Recidive (Persistent Attackers)
```bash
[recidive]
enabled  = true
logpath  = /var/log/fail2ban.log
bantime  = 7d
findtime = 1d
maxretry = 5

```
## Testing Filters
# Before enabling a jail, test the filter against logs:

```bash
fail2ban-regex /var/log/nginx/access.log laravel-scan.conf
```

# This helps verify regex accuracy and avoid false positives.

## Notes

# If you use phpMyAdmin occasionally, whitelist your IP to avoid lockouts.

# Adjust bantime and maxretry depending on traffic level.

# Filters are framework-agnostic where possible.

# Intended for servers exposed to public traffic.

## How It Works

A simplified view of traffic flow and defense:

     ┌────────────┐
     │   Client   │
     └─────┬──────┘
           │ HTTP/HTTPS or SSH
           ▼
     ┌────────────┐
     │   Nginx    │
     │  (reverse  │
     │   proxy /  │
     │ request    │
     │ filtering) │
     └─────┬──────┘
           │ Logs suspicious activity
           ▼
     ┌────────────┐
     │ Fail2Ban   │
     │  (monitors │
     │ logs &     │
     │ bans IPs)  │
     └─────┬──────┘
           │ Blocks malicious IPs via firewall
           ▼
     ┌────────────┐
     │  Firewall  │
     │  (iptables,│
     │  nftables, │
     │  etc.)     │
     └─────┬──────┘
           │ Limits system access
           ▼
     ┌────────────┐
     │  SELinux / │
     │  AppArmor  │
     │  (sandbox  │
     │   services │
     │   & restrict│
     │   files)   │
     └─────┬──────┘
           │
           ▼
     ┌────────────┐
     │ Web App /  │
     │ Services   │
     │ Laravel,   │
     │ WordPress, │
     │ Node.js,   │
     │ etc.       │
     └────────────┘

## Installation

1. Copy the filter files to `/etc/fail2ban/filter.d/`  
2. Copy the jail configurations to `/etc/fail2ban/jail.d/`  
3. Adjust the jail settings (`findtime`, `bantime`, `maxretry`) as needed  
4. Reload Fail2Ban:

```bash
sudo fail2ban-client -t # Verify the filter
sudo systemctl reload fail2ban
```

## Testing Filters and Jails
# Test a filter against a log file:

```bash
fail2ban-regex /var/log/nginx/access.log /etc/fail2ban/filter.d/laravel-scan.conf
```

# Check jail status:
```bash
sudo fail2ban-client status
sudo fail2ban-client status <jail-name>
```

# Test Nginx configuration:
```bash
sudo nginx -t
```

----
**Recommended OS:** RHEL-based distributions

[![Hitsukaya](https://hitsukaya.com/assets/images/summary_large_image/summary_large_image-hitsukaya.png)](https://hitsukaya.com) 

