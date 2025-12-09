[![Hitsukaya](https://img.shields.io/badge/Hitsukaya-red)](https://hitsukaya.com)
[![Fail2Ban](https://img.shields.io/badge/Fail2Ban-protected-brightgreen)](https://www.fail2ban.org/)
[![Nginx](https://img.shields.io/badge/Nginx-webserver-blue)](https://nginx.org/)

# Laravel & WordPress Fail2Ban Filter

A **Fail2Ban filter** to protect Laravel, WordPress, and Node.js frameworks (Next.js/Nuxt) applications from common attacks, automated scans, and unauthorized access to sensitive files.

---

## What this filter does

- Protects sensitive files and configurations (`.env`, `.git`, `.htaccess`, `artisan`, etc.)  
- Blocks attempts to access Laravel debug and log tools (`_debugbar`, `telescope`, `horizon`)  
- Secures WordPress paths (`wp-admin`, `wp-login.php`, `xmlrpc.php`, `wp-content`)  
- Protects Node.js / Next.js / Nuxt frameworks (`package-lock.json`, `yarn.lock`, `.next/`, `.nuxt/`)  
- Detects dangerous uploads, backups, and database dumps  
- Prevents directory traversal, RCE, or injection attempts (`?cmd=`, `?exec=`, etc.)  
- Blocks crawlers and automated scanners

---

## Installation

### 1. Create the Fail2Ban filter

Save the filter content into a file, for example:

```bash
sudo nano /etc/fail2ban/filter.d/laravel-wordpress.conf
```

```bash
[Definition]
# HITSUKAYA MASTER FILTER 
# Powered by Valentaizar Hitsukaya - Update December 2025, 09
# The power is power, but the brain is the most powerful tool

# =========================
# Sensitive files & config
# =========================
failregex = ^<HOST> -.*"(GET|POST).*\.env.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.env\.example.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.git.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.gitignore.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.htaccess.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.htpasswd.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*artisan.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*vendor/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*storage/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*bootstrap/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*config/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*package.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*Dockerfile.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*docker-compose.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*webpack.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*vite.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*gulpfile.*HTTP.*"
			^<HOST> -.*"(?:(GET|POST).*\.env).*" [45]\d{2} .*

# =========================
# Laravel debug & logs
# =========================
            ^<HOST> -.*"(GET|POST).*/_debugbar.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/telescope.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/horizon.*HTTP.*"

# =========================
# WordPress & CMS common paths & other
# =========================
            ^<HOST> -.*"(GET|POST).*wp-admin.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*wp-login\.php.*HTTP.*"
            ^<HOST> -.*"(POST).*xmlrpc\.php.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*setup-config\.php.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*wordpress.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*wp-json/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/wp-content/.*\.php.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/wp-content/plugins/.*HTTP.*"
			^<HOST> -.*"(GET|POST).*/phpmyadmin/.*HTTP.*"
			^<HOST> -.*"(GET|POST).*/adminer\.php.*HTTP.*"
			^<HOST> -.*"(POST).*/wp-json/wp/v2/.*HTTP.*"
			# UPDATE - 09.12.2012  
			^<HOST> -.*"(GET|POST|HEAD) /(wp-admin|wp-login\.php).* HTTP.*"
			^<HOST> -.*"(POST) /xmlrpc\.php.* HTTP.*"
			^<HOST> -.*"(GET|POST) .*setup-config\.php.* HTTP.*"
			^<HOST> -.*"(GET|POST) .*/wp-content/.*\.php.* HTTP.*"
			^<HOST> -.*"(GET|POST) .*/wp-includes/.*\.php.* HTTP.*"
			^<HOST> -.*"(GET|POST) .*/wp-content/(plugins|themes|uploads)/.* HTTP.*"
			^<HOST> -.*"(POST) /wp-json/wp/v2/.* HTTP.*"
			^<HOST> -.*"(GET|POST) .*/(phpmyadmin|phpMyAdmin|pma|adminer\.php).* HTTP.*"
			^<HOST> -.*"(GET|POST) .*\.(env|env\.local|env\.dist|git/config).* HTTP.*"
			^<HOST> -.*"(GET|POST) .*(classwithtostring|radio|chosen|about|wp-conflg|index\.php\?|x\.php|alfa|ioxi|1\.php|wp-blog|wp-good)\.php.* HTTP.*"			

# =========================
# Node.js / Next.js / Nuxt
# =========================
            ^<HOST> -.*"(GET|POST).*next\.config\.js.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*nuxt\.config\.js.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*tsconfig\.json.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*vue\.config\.js.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*server\.js.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*app\.js.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.next/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.nuxt/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*package-lock\.json.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*yarn\.lock.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*pnpm-lock\.yaml.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/dist/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/node_modules/.*HTTP.*"
			^<HOST> -.*"(POST).*/api/.*HTTP.*"
			^<HOST> -.*"(POST).*/api/(login|auth|register|password).*HTTP.*"			

# =========================
# Uploads / backup / temp / dumps
# =========================
            ^<HOST> -.*"(GET|POST).*/uploads/.*\.(php|php5|phtml|phar|asp|aspx|jsp|sh).*HTTP.*
            ^<HOST> -.*"(GET|POST).*\.(swp|swx|bak|old|orig|tmp|~).*HTTP.*
            ^<HOST> -.*"(GET|POST).*backup/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*dump\.sql.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*database\.sql.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.sql.*HTTP.*"
			^<HOST> -.*"(GET|POST).*/uploads/.*\.(exe|dll|jar|py|rb).*HTTP.*"

# =========================
# Traversal / RCE / injection attempts
# =========================
            ^<HOST> -.*"(GET|POST).*\.\./.*HTTP.*
            ^<HOST> -.*"(GET|POST).*\?cmd=.*HTTP.*
            ^<HOST> -.*"(GET|POST).*\?exec=.*HTTP.*
            ^<HOST> -.*"(GET|POST).*\?shell=.*HTTP.*
            ^<HOST> -.*"(GET|POST).*\?ping=.*HTTP.*
            ^<HOST> -.*"(GET|POST).*\?run=.*HTTP.*
            ^<HOST> -.*"(POST).*/api/(login|auth).*HTTP.*
			^<HOST> -.*"(POST).*/admin/login.*HTTP.*"

# =========================
# Crawlers / scanners / automated requests
# =========================
            ^<HOST> -.*"(GET|POST).*wp-admin/.*\.xml.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/\.git/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/\.env/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/\.htaccess/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/favicon\.ico.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/robots\.txt.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*/sitemap\.xml.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*\.well-known/.*HTTP.*"
            ^<HOST> -.*"(GET|POST).*acme-challenge.*HTTP.*"

# =========================
# FastCGI Primary script unknown
# =========================
            ^.*FastCGI sent in stderr: "Primary script unknown" while reading response header from upstream, client: <HOST>.*, request: ".*"

ignoreregex =


# =========================
# Ignored regex (legit crawlers / SSL noise)
# =========================
#ignoreregex = .*Googlebot.*|.*bingbot.*|.*DuckDuckBot.*|.*Baiduspider.*|.*SSL_do_handshake.*|.*bad certificate.*|.*no shared cipher.*|.*connection reset by peer.*

```

### 2. Create the jail

Create or edit a local jail configuration:

```bash
sudo nano /etc/fail2ban/jail.d/laravel-wordpress.local
```

```bash
[laravel-wordpress]
enabled  = true
port     = http,https
filter   = laravel-wordpress
logpath  = /var/log/nginx/access.log /var/log/nginx/error.log
maxretry = 1
bantime  = -1
banaction = iptables-multiport
findtime = 600
ignoreip = 127.0.0.1/8 ::1 <YOUR-IP-HERE>
persistent = true
```
## Replace <YOUR-IP-HERE> with your IP to avoid accidentally banning yourself.

### 3. Test the filter

```bash
sudo fail2ban-client reload
sudo fail2ban-client status laravel-wordpress
```

### Recommended settings
- bantime = -1 → permanently ban attackers
- maxretry = 1 → block on the first suspicious attempt
- findtime = 600 → 10-minute detection window
- ignoreip → include your IP and other admin IPs

### Example of detected logs
```bash
192.168.1.100 - - [16/Sep/2025:09:00:01 +0300] "GET /.env HTTP/1.1" 404 162 "-" "curl/7.68.0"
203.0.113.45 - - [16/Sep/2025:09:05:12 +0300] "POST /wp-login.php HTTP/1.1" 404 245 "-" "Mozilla/5.0"
```
**Recommended OS:** RHEL-based distributions

[![Hitsukaya](https://hitsukaya.com/assets/images/summary_large_image/summary_large_image-hitsukaya.png)](https://hitsukaya.com) 

