#!/bin/bash

# Create new Hugo site if it doesn't exist
if [ ! -d "/var/www/hugo/site" ]; then
    hugo new site site
    cd site || exit

    git init
    git config --global --add safe.directory /var/www/hugo/site

    git submodule add https://github.com/nanxiaobei/hugo-paper.git themes/paper
    git submodule init
    git submodule update --init --recursive
    git submodule update --remote --merge

    if [ ! -d "themes/paper" ]; then
        echo "Error: Theme installation failed"
        exit 1
    fi

    mkdir -p static/images
    mkdir -p content/{containers,security,posts}
    mkdir -p content/containers/{nginx,wordpress,mariadb}
    mkdir -p content/security/{fail2ban,ssl,docker,wordpress}
    mkdir -p content/posts/troubleshooting

    rm -rf content/containers/_index.md
    rm -rf content/security/_index.md
    rm -rf content/posts/_index.md

    touch content/_index.md
    touch content/containers/_index.md
    touch content/security/_index.md
    touch content/posts/_index.md
    touch content/containers/redis.md
   touch content/containers/ftp.md
   touch content/containers/adminer.md
   touch content/security/docker.md
   touch content/security/wordpress.md
    
    chmod -R 755 content/
    ls -R content/

cat > hugo.toml <<EOL
baseURL = 'https://hugo.${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'Inception'
theme = 'paper'

# Basic parameters
[params]
  # Theme parameters
  github = 'mrioshe42'
  avatar = '/images/42logo.png'
  name = 'Inception Project Documentation'
  bio = 'Docker Infrastructure Setup with Security Measures'
  
  # Default theme settings - these ensure proper styling
  defaultTheme = "auto"  # auto, dark, or light
  
  # Disable features we don't need
  disableHLJS = true    # We're using our own code highlighting
  monoDarkIcon = true   # Use monochrome icons in dark mode

[menu]
  [[menu.main]]
    identifier = "containers"
    name = "Container Setup"
    url = "/containers/"
    weight = 10
  
  [[menu.main]]
    identifier = "security"
    name = "Security"
    url = "/security/"
    weight = 20
  
  [[menu.main]]
    identifier = "troubleshooting"
    name = "Troubleshooting"
    url = "/posts/troubleshooting/"
    weight = 30

  # Add submenus for containers
  [[menu.containers]]
    name = "NGINX"
    url = "/containers/nginx/"
    weight = 1
  [[menu.containers]]
    name = "WordPress"
    url = "/containers/wordpress/"
    weight = 2
  [[menu.containers]]
    name = "MariaDB"
    url = "/containers/mariadb/"
    weight = 3

  # Add submenus for security
  [[menu.security]]
    name = "Fail2Ban"
    url = "/security/fail2ban/"
    weight = 1
  [[menu.security]]
    name = "SSL/TLS"
    url = "/security/ssl/"
    weight = 2
  [[menu.security]]
    name = "Docker Security"
    url = "/security/docker/"
    weight = 3
  [[menu.security]]
    name = "WordPress Security"
    url = "/security/wordpress/"
    weight = 4
EOL


cat > content/_index.md <<EOL
---
title: "Inception Project Documentation"
date: $(date +%Y-%m-%d)
draft: false
type: "page"
layout: "single"
---

# Welcome to Inception Project

{{< figure src="/images/docker-diagram.png" alt="Docker Infrastructure" title="Project Infrastructure Overview" >}}

## Project Overview

The Inception project is a comprehensive system administration exercise that focuses on Docker containerization and service orchestration. This project implements a complete web infrastructure using Docker containers.

### Core Infrastructure Components

#### 1. NGINX Server (Front-end)
- SSL/TLS encryption
- Reverse proxy configuration
- Static file serving

#### 2. WordPress + PHP-FPM (Application)
- Dynamic content management
- PHP processing
- Custom configurations

#### 3. MariaDB (Database)
- Data persistence
- Secure database operations
- Backup management

## Quick Navigation

### Core Services
- [NGINX Setup](/containers/nginx/)
- [WordPress Setup](/containers/wordpress/)
- [MariaDB Setup](/containers/mariadb/)

### Additional Services
- [Redis Cache](/containers/redis/)
- [FTP Server](/containers/ftp/)
- [Adminer](/containers/adminer/)

### Security
- [Fail2Ban Configuration](/security/fail2ban/)
- [SSL/TLS Security](/security/ssl/)
- [Docker Security](/security/docker/)
- [WordPress Security](/security/wordpress/)

### Support
- [Troubleshooting Guide](/posts/troubleshooting/)

## Getting Started

1. **Clone Repository**
\`\`\`bash
git clone https://github.com/mrioshe42/Inception.git
cd Inception
\`\`\`

2. **Environment Setup**
\`\`\`bash
cp .env.example .env
# Edit .env with your configuration
\`\`\`

3. **Build and Deploy**
\`\`\`bash
make all
\`\`\`

## System Requirements

- Docker Engine
- Docker Compose
- Make utility
- Minimum 4GB RAM
- 10GB free disk space

## Network Requirements

- Port 443 (HTTPS)
- Port 21 (FTP)
- Port 22 (SSH)
EOL


cat > content/containers/_index.md <<EOL
---
title: "Container Setup Guides"
date: $(date +%Y-%m-%d)
draft: false
---

# Container Setup Guides

## Available Guides

### Core Services
- [NGINX Configuration](/containers/nginx/)
- [WordPress & PHP-FPM Setup](/containers/wordpress/)
- [MariaDB Database](/containers/mariadb/)

### Additional Services
- [Redis Cache](/containers/redis/)
- [FTP Server](/containers/ftp/)
- [Adminer](/containers/adminer/)

[Back to Home](/)
EOL

cat > content/containers/nginx.md <<EOL
---
title: "NGINX Setup Guide"
date: $(date +%Y-%m-%d)
draft: false
---

# NGINX Container Setup

## Configuration Steps

1. **SSL Certificate Generation**
   \`\`\`bash
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
           -keyout /etc/nginx/ssl/inception.key \
           -out /etc/nginx/ssl/inception.crt
   \`\`\`

2. **NGINX Configuration**
   \`\`\`nginx
   server {
       listen 443 ssl;
       server_name ${DOMAIN_NAME};
       
       ssl_certificate /etc/nginx/ssl/inception.crt;
       ssl_certificate_key /etc/nginx/ssl/inception.key;
       
       # SSL configuration
       ssl_protocols TLSv1.2 TLSv1.3;
       ssl_prefer_server_ciphers off;
       
       root /var/www/wordpress;
       index index.php;
       
       # WordPress PHP handling
       location ~ \.php$ {
           fastcgi_pass wordpress:9000;
           fastcgi_index index.php;
           include fastcgi_params;
       }
   }
   \`\`\`

3. **Docker Configuration**
   - Port mapping (443)
   - Volume mounts
   - Network setup

4. **Testing**
   - SSL verification
   - Connection testing
   - Log monitoring
## Navigation

- [Back to Container Guides](/containers/)
- [Back to Home](/)
- [Security Configuration](/security/)
- [Troubleshooting Guide](/posts/troubleshooting/)
EOL

cat > content/containers/wordpress.md <<EOL
---
title: "WordPress & PHP-FPM Setup"
date: $(date +%Y-%m-%d)
draft: false
---

# WordPress and PHP-FPM Configuration

## Installation Steps

1. **PHP-FPM Setup**
   \`\`\`bash
   # PHP-FPM configuration
   sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf
   \`\`\`

2. **WordPress Installation**
   \`\`\`bash
   # Download and configure WordPress
   wp core download
   wp config create --dbname=\${DB_NAME} --dbuser=\${DB_USER} --dbpass=\${DB_PASS}
   wp core install --url=https://\${DOMAIN_NAME} --title="Inception" --admin_user=\${WP_ADMIN} --admin_password=\${WP_ADMIN_PASS}
   \`\`\`

3. **Performance Optimization**
   - PHP-FPM pool settings
   - OPcache configuration
   - Memory limits

4. **Plugin Management**
   - Essential plugins
   - Security plugins
   - Cache plugins

## Navigation

- [Back to Container Guides](/containers/)
- [Back to Home](/)
- [Security Configuration](/security/)
- [Troubleshooting Guide](/posts/troubleshooting/)
EOL

cat > content/containers/mariadb.md <<EOL
---
title: "MariaDB Setup"
date: $(date +%Y-%m-%d)
draft: false
---

# MariaDB Database Configuration

## Setup Instructions

1. **Initial Configuration**
   \`\`\`bash
   # Secure installation
   mysql_secure_installation
   
   # Create database and user
   mysql -e "CREATE DATABASE \${DB_NAME};"
   mysql -e "CREATE USER '\${DB_USER}'@'%' IDENTIFIED BY '\${DB_PASS}';"
   mysql -e "GRANT ALL PRIVILEGES ON \${DB_NAME}.* TO '\${DB_USER}'@'%';"
   \`\`\`

2. **Performance Tuning**
   - Buffer pool size
   - Query cache
   - Connection limits

3. **Backup Configuration**
   - Automated backups
   - Backup verification
   - Restore procedures
## Navigation

- [Back to Container Guides](/containers/)
- [Back to Home](/)
- [Security Configuration](/security/)
- [Troubleshooting Guide](/posts/troubleshooting/)
EOL


cat > content/security/_index.md <<EOL
---
title: "Security Measures"
date: $(date +%Y-%m-%d)
draft: false
---

# Security Implementation Guide

- [Fail2Ban Configuration](/security/fail2ban)
- [SSL/TLS Security](/security/ssl)
- [Docker Security](/security/docker)
- [WordPress Security](/security/wordpress)
EOL

cat > content/security/fail2ban.md <<EOL
---
title: "Fail2Ban Configuration"
date: 2024-12-19
draft: false
---

# Fail2Ban Security Implementation

## Overview
Fail2Ban is implemented in our Inception project to protect various services against brute-force attacks and unauthorized access attempts.

## Implementation Details

### 1. Jail Configuration
\`\`\`ini
# /etc/fail2ban/jail.local
[wordpress]
enabled = true
port = http,https
filter = wordpress
logpath = /var/log/nginx/access.log
maxretry = 5
findtime = 600
bantime = 600

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3
findtime = 600
bantime = 600
\`\`\`

### 2. Custom Filter for WordPress
\`\`\`ini
# /etc/fail2ban/filter.d/wordpress.conf
[Definition]
failregex = ^<HOST> .* "POST /wp-login.php
            ^<HOST> .* "POST /xmlrpc.php
ignoreregex =
\`\`\`

## Key Security Features

### 1. Ban Parameters
- **maxretry**: 5 attempts
- **findtime**: 10 minutes (600 seconds)
- **bantime**: 10 minutes (600 seconds)
- **banaction**: iptables-multiport

### 2. Protected Services
1. **WordPress Login**
   - Monitors failed login attempts
   - Protects wp-login.php and xmlrpc.php
   - Custom regex patterns for attack detection

2. **NGINX Basic Auth**
   - Monitors authentication failures
   - Protects restricted areas
   - Logs stored in error.log

3. **SSH Protection**
   - Prevents unauthorized access attempts
   - Default SSH port monitoring
   - Aggressive ban rules for repeat offenders

## Implementation Steps

1. **Installation in Docker**
\`\`\`dockerfile
# Dockerfile excerpt
RUN apt-get update && apt-get install -y fail2ban
COPY ./conf/fail2ban/jail.local /etc/fail2ban/jail.local
COPY ./conf/fail2ban/wordpress.conf /etc/fail2ban/filter.d/wordpress.conf
\`\`\`

2. **Service Configuration**
\`\`\`bash
# Start Fail2Ban service
service fail2ban start

# Verify status
fail2ban-client status
fail2ban-client status wordpress
\`\`\`

## Monitoring and Maintenance

### 1. Check Ban Status
\`\`\`bash
# View currently banned IPs
fail2ban-client status wordpress

# View ban logs
tail -f /var/log/fail2ban.log
\`\`\`

### 2. Managing Bans
\`\`\`bash
# Unban an IP
fail2ban-client set wordpress unbanip X.X.X.X

# Ban an IP manually
fail2ban-client set wordpress banip X.X.X.X
\`\`\`

## Troubleshooting

### Common Issues

1. **Logs Not Being Monitored**
   - Check log paths in jail.conf
   - Verify log file permissions
   - Ensure log rotation isn't interrupting monitoring

2. **False Positives**
   - Add legitimate IPs to ignoreip
   - Adjust findtime and maxretry values
   - Review regex patterns

3. **Service Not Starting**
   - Check fail2ban service status
   - Review error logs
   - Verify configuration syntax

## Best Practices

1. **Regular Maintenance**
   - Monitor false positives
   - Review ban logs periodically
   - Update filters as needed
   - Backup configurations

2. **Configuration Tips**
   - Use persistent bans for repeat offenders
   - Implement whitelisting for trusted IPs
   - Configure email notifications
   - Regular log rotation

3. **Security Recommendations**
   - Keep Fail2Ban updated
   - Use custom ports where possible
   - Implement aggressive bans for serious violations
   - Monitor for new attack patterns

## Additional Resources
- Fail2Ban Documentation: [Official Fail2Ban Documentation](https://www.fail2ban.org/wiki/index.php/Main_Page)
- Log Analysis Tools
- Security Best Practices
EOL

cat > content/security/ssl.md <<EOL
---
title: "SSL/TLS Security"
date: $(date +%Y-%m-%d)
draft: false
---

# SSL/TLS Security Configuration

## Overview
Our Inception project implements robust SSL/TLS security measures to ensure encrypted communication between clients and services.

## SSL/TLS Implementation

### 1. Certificate Configuration
\`\`\`bash
# Generate SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42Paris/CN=${DOMAIN_NAME}"
\`\`\`

### 2. NGINX SSL Configuration
\`\`\`nginx
# SSL configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;

# SSL certificate paths
ssl_certificate /etc/nginx/ssl/inception.crt;
ssl_certificate_key /etc/nginx/ssl/inception.key;

# Additional security headers
add_header Strict-Transport-Security "max-age=31536000" always;
add_header X-Frame-Options SAMEORIGIN;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
\`\`\`

## Security Measures

### 1. Protocol Settings
- TLS 1.2 and 1.3 only
- Older SSL versions disabled
- Modern cipher suite configuration

### 2. Certificate Management
- Self-signed certificates
- 2048-bit RSA keys
- 1-year validity period
- Automatic renewal process

### 3. Security Headers
- HSTS implementation
- XSS protection
- Clickjacking prevention
- MIME type sniffing protection

## Implementation Steps

1. **Generate Certificates**
   - Create SSL directory
   - Generate self-signed certificate
   - Set proper permissions

2. **Configure NGINX**
   - Enable SSL module
   - Configure SSL parameters
   - Add security headers

3. **Testing and Verification**
   - SSL Labs test
   - Certificate validation
   - Security header checks

## Best Practices

### 1. Certificate Management
- Regular certificate rotation
- Secure key storage
- Backup procedures
- Monitoring expiration dates

### 2. Security Configuration
- Regular security audits
- Cipher suite updates
- Security header maintenance
- SSL/TLS version management

### 3. Monitoring
- Certificate expiration alerts
- SSL/TLS handshake errors
- Security header effectiveness
- Client compatibility issues
EOL

cat > content/posts/troubleshooting/_index.md <<EOL
---
title: "Troubleshooting Guide"
date: $(date +%Y-%m-%d)
draft: false
---

# Troubleshooting Guide

## Common Issues and Solutions

### Container Issues

1. **Container Won't Start**
   - Check logs: \`docker logs <container_name>\`
   - Verify ports: \`docker port <container_name>\`
   - Check volume permissions

2. **Database Connection Issues**
   - Verify environment variables
   - Check network connectivity
   - Confirm MariaDB service is running

### WordPress Issues

1. **White Screen of Death**
   - Enable WP_DEBUG in wp-config.php
   - Check PHP error logs
   - Disable plugins temporarily

2. **Cannot Upload Media**
   - Check directory permissions
   - Verify PHP upload limits
   - Check available disk space

### NGINX Issues

1. **SSL Certificate Problems**
   - Verify certificate paths
   - Check certificate validity
   - Confirm proper permissions

2. **502 Bad Gateway**
   - Check PHP-FPM status
   - Verify fastcgi_pass configuration
   - Check error logs

### Security Issues

1. **Fail2Ban Not Working**
   - Check service status
   - Verify log paths
   - Review jail configurations

2. **SSL/TLS Warnings**
   - Update cipher configurations
   - Check protocol settings
   - Verify certificate chain

## Debug Commands

\`\`\`bash
# Check container status
docker ps -a

# View container logs
docker logs <container_name>

# Check NGINX configuration
nginx -t

# Test PHP-FPM
cgi-fcgi -bind -connect 127.0.0.1:9000

# View MariaDB logs
tail -f /var/log/mysql/error.log

# Check Fail2Ban status
fail2ban-client status
\`\`\`

## Support Resources

- [Docker Documentation](https://docs.docker.com/)
- [WordPress Debugging](https://wordpress.org/support/article/debugging-in-wordpress/)
- [NGINX Docs](https://nginx.org/en/docs/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
EOL
    hugo --cleanDestinationDir --verbose

    git add .
    git commit -m "Updated documentation structure with security focus"
else
    cd site || exit
fi

hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL="https://hugo.${DOMAIN_NAME}" \
    --appendPort=false \
    --disableFastRender \
    --ignoreCache \
    --verbose