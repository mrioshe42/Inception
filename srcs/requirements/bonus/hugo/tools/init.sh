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

   rm -rf content/containers/_index.md
   rm -rf content/security/_index.md
   rm -rf content/posts/_index.md
   mkdir -p content/{containers/{nginx,wordpress,mariadb},security/{fail2ban,ssl,docker,wordpress}}
   touch content/_index.md
   touch content/containers/_index.md
   touch content/security/_index.md
   touch content/posts/_index.md
   touch content/containers/redis.md
   touch content/containers/ftp.md
   touch content/containers/adminer.md
   touch content/security/docker.md
   touch content/security/wordpress.md
      # Update the Quick Navigation section
   sed -i 's|/containers/nginx/|containers/nginx/|g' content/_index.md
   sed -i 's|/containers/wordpress/|containers/wordpress/|g' content/_index.md
   sed -i 's|/containers/mariadb/|containers/mariadb/|g' content/_index.md
   sed -i 's|/containers/redis/|containers/redis/|g' content/_index.md
   sed -i 's|/containers/ftp/|containers/ftp/|g' content/_index.md
   sed -i 's|/containers/adminer/|containers/adminer/|g' content/_index.md
   sed -i 's|/security/fail2ban/|security/fail2ban/|g' content/_index.md
   sed -i 's|/security/ssl/|security/ssl/|g' content/_index.md
   sed -i 's|/security/docker/|security/docker/|g' content/_index.md
   sed -i 's|/security/wordpress/|security/wordpress/|g' content/_index.md
   sed -i 's|/containers/|containers/|g' content/_index.md
sed -i 's|/security/|security/|g' content/_index.md
   ls -R content/
chmod -R 755 content/
mkdir -p archetypes
   cat > archetypes/default.md <<EOL
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
weight: {{ .Site.RegularPages | len }}
---
EOL

cat > hugo.toml <<EOL
baseURL = 'https://hugo.${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'Inception'
theme = 'paper'

[params]
  # Theme appearance
  color = 'gray'
  avatar = '/images/42logo.png'
  name = 'Inception Project Documentation'
  bio = 'Docker Infrastructure Setup with Security Measures'
  
  # Theme behavior
  defaultTheme = "dark"
  monoDarkIcon = true
  showDate = true
  showFullContent = true
  mainSections = ["containers", "security"]
  showBreadcrumbs = true
  
  # Social links
  github = 'mrioshe42'

[menu]
  [[menu.main]]
    name = "Home"
    url = "/"
    weight = 1
  [[menu.main]]
    name = "Containers"
    url = "/containers/"
    weight = 2
  [[menu.main]]
    name = "Security"
    url = "/security/"
    weight = 3

[markup.goldmark.renderer]
  unsafe = true

[outputs]
  home = ["HTML", "RSS"]
  section = ["HTML", "RSS", "JSON"]
EOL


cat > content/_index.md <<EOL
---
title: "Inception Project Documentation"
date: $(date +%Y-%m-%d)
draft: false
type: "page"
layout: "single"
---

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

EOL


cat > content/containers/_index.md <<EOL
---
title: "Container Setup Guides"
date: $(date +%Y-%m-%d)
draft: false
---

# Container Setup Guides

## Core Services

### NGINX
- [NGINX Configuration](nginx/)
  - SSL/TLS setup
  - Proxy configuration
  - PHP-FPM integration

### WordPress
- [WordPress & PHP-FPM Setup](wordpress/)
  - PHP-FPM configuration
  - WordPress installation
  - Performance tuning

### MariaDB
- [MariaDB Database](mariadb/)
  - Initial setup
  - User management
  - Backup configuration

## Additional Services

### Redis
- [Redis Cache](redis/)
  - Cache configuration
  - WordPress integration
  - Performance monitoring

### FTP
- [FTP Server](ftp/)
  - VSFTPD setup
  - Security measures
  - User management

### Adminer
- [Adminer](adminer/)
  - Database management
  - Web interface setup
  - Access control
EOL

cat > content/containers/nginx.md <<EOL
---
title: "NGINX Setup Guide"
date: $(date +%Y-%m-%d)
draft: false
---

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

## Access Control

### Fail2Ban
- [Fail2Ban Configuration](fail2ban/)
  - Brute force protection
  - Custom jail setup
  - Login security

### SSL/TLS
- [SSL/TLS Security](ssl/)
  - Certificate management
  - Protocol configuration
  - Security headers

## Container Security

### Docker
- [Docker Security](docker/)
  - Container isolation
  - Image hardening
  - Runtime protection

### WordPress
- [WordPress Security](wordpress/)
  - Core hardening
  - Plugin security
  - Access control
EOL

cat > content/security/fail2ban.md <<EOL
---
title: "Fail2Ban Configuration"
date: 2024-12-19
draft: false
---

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

cat > content/containers/redis.md <<EOL
---
title: "Redis Cache Setup"
date: 2024-12-20
draft: false
---

## Overview
Redis is implemented as a caching layer to improve WordPress performance by storing frequently accessed data in memory.

## Installation Steps

1. **Docker Configuration**
   \`\`\`dockerfile
   FROM redis:alpine

   # Copy custom Redis configuration
   COPY redis.conf /usr/local/etc/redis/redis.conf

   # Expose Redis port
   EXPOSE 6379

   # Start Redis with custom config
   CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
   \`\`\`

2. **Basic Configuration**
   \`\`\`conf
   # Redis configuration
   maxmemory 256mb
   maxmemory-policy allkeys-lru
   appendonly yes
   protected-mode no
   \`\`\`

3. **WordPress Integration**
   - Install Redis Object Cache plugin
   - Add Redis configuration to wp-config.php:
   \`\`\`php
   define('WP_CACHE', true);
   define('WP_REDIS_HOST', 'redis');
   define('WP_REDIS_PORT', 6379);
   \`\`\`

## Performance Tuning

1. **Memory Management**
   - Adjust maxmemory based on available resources
   - Monitor memory usage patterns
   - Configure appropriate eviction policies

2. **Persistence Settings**
   - Enable AOF for data persistence
   - Configure save points
   - Backup strategy

## Monitoring

1. **Key Metrics**
   - Memory usage
   - Hit/miss ratio
   - Connected clients
   - Eviction stats

2. **Commands**
   \`\`\`bash
   # Monitor Redis
   redis-cli monitor

   # Check stats
   redis-cli info

   # Memory analysis
   redis-cli memory stats
   \`\`\`

## Security Considerations

1. **Network Security**
   - Restrict access to Redis port
   - Use password authentication
   - Configure bind addresses

2. **Data Protection**
   - Enable encrypted connections
   - Regular backups
   - Access control lists
EOL

cat > content/containers/ftp.md <<EOL
---
title: "FTP Server Setup"
date: 2024-12-20
draft: false
---

## Overview
Setup and configuration of a secure FTP server for file transfers in the Inception infrastructure.

## Installation Steps

1. **Docker Configuration**
   \`\`\`dockerfile
   FROM alpine:latest
   
   RUN apk add --no-cache vsftpd
   
   COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
   
   EXPOSE 21
   \`\`\`

2. **Basic Configuration**
   \`\`\`conf
   # FTP configuration
   listen=YES
   anonymous_enable=NO
   local_enable=YES
   write_enable=YES
   chroot_local_user=YES
   allow_writeable_chroot=YES
   pasv_enable=YES
   pasv_min_port=21100
   pasv_max_port=21110
   \`\`\`

3. **Security Measures**
   - SSL/TLS encryption
   - Chroot jail configuration
   - User access control
   - Passive mode settings

## Usage Guide

1. **Connection Details**
   - Port: 21 (FTP)
   - Passive Ports: 21100-21110
   - Authentication: Local user accounts

2. **Commands**
   \`\`\`bash
   # Start FTP service
   vsftpd /etc/vsftpd/vsftpd.conf
   
   # Monitor logs
   tail -f /var/log/vsftpd.log
   \`\`\`

## Troubleshooting

1. **Common Issues**
   - Connection timeouts
   - Authentication failures
   - Passive mode problems
   - Permission errors
EOL

# Add content for Adminer
cat > content/containers/adminer.md <<EOL
---
title: "Adminer Setup"
date: 2024-12-20
draft: false
---

## Overview
Installation and configuration of Adminer for database administration.

## Setup Instructions

1. **Docker Configuration**
   \`\`\`dockerfile
   FROM adminer:latest
   
   EXPOSE 8080
   \`\`\`

2. **NGINX Proxy Configuration**
   \`\`\`nginx
   location /adminer {
       proxy_pass http://adminer:8080;
       proxy_set_header Host \$host;
       proxy_set_header X-Real-IP \$remote_addr;
   }
   \`\`\`

3. **Security Measures**
   - Access restrictions
   - SSL/TLS encryption
   - IP whitelisting
   - Authentication requirements

## Usage Guide

1. **Accessing Adminer**
   - URL: https://your-domain/adminer
   - Supported databases: MySQL, PostgreSQL, SQLite
   - Login with database credentials

2. **Key Features**
   - Database management
   - Table operations
   - SQL query execution
   - Data import/export
EOL

# Add content for Docker Security
cat > content/security/docker.md <<EOL
---
title: "Docker Security"
date: 2024-12-20
draft: false
---

## Overview
Security best practices and configurations for Docker containers in the Inception project.

## Security Measures

1. **Container Isolation**
   - Network segmentation
   - Resource limitations
   - User namespace mapping
   - Container privileges

2. **Image Security**
   \`\`\`dockerfile
   # Use specific versions
   FROM alpine:3.14
   
   # Run as non-root
   USER nobody
   
   # Minimal installations
   RUN apk add --no-cache package
   \`\`\`

3. **Runtime Security**
   - Read-only root filesystem
   - Drop capabilities
   - Secure computing modes
   - Resource quotas

## Best Practices

1. **Container Hardening**
   - Regular security updates
   - Minimal base images
   - Proper secret management
   - Health monitoring

2. **Network Security**
   - Internal networks
   - Port exposure limits
   - TLS authentication
   - Network policies
EOL

cat > content/security/wordpress.md <<EOL
---
title: "WordPress Security"
date: 2024-12-20
draft: false
---

## Overview
Comprehensive security measures for the WordPress installation.

## Security Implementations

1. **Core Security**
   - Regular updates
   - Strong passwords
   - File permissions
   - wp-config.php protection

2. **Plugin Security**
   \`\`\`php
   // Security plugin configurations
   define('DISALLOW_FILE_EDIT', true);
   define('WP_AUTO_UPDATE_CORE', true);
   \`\`\`

3. **Access Control**
   - Login attempt limits
   - Two-factor authentication
   - Role-based access
   - Admin area protection

## Best Practices

1. **Maintenance**
   - Regular backups
   - Security scans
   - Log monitoring
   - Update management

2. **Hardening Measures**
   - Remove version information
   - Disable XML-RPC
   - Protect sensitive files
   - Secure media uploads
EOL
 # Update navigation in all container pages
   find content/containers -type f -name "*.md" -exec sed -i 's|- \[Back to Container Guides\](/containers/)|- [Back to Container Guides](../)|g' {} \;
   find content/containers -type f -name "*.md" -exec sed -i 's|- \[Back to Home\](/)|[Back to Home](../../)|g' {} \;
   find content/containers -type f -name "*.md" -exec sed -i 's|- \[Security Configuration\](/security/)|- [Security Configuration](../../security/)|g' {} \;

   # Update navigation in all security pages
   find content/security -type f -name "*.md" -exec sed -i 's|- \[Back to Security\](../security/)|- [Back to Security](../)|g' {} \;
   find content/security -type f -name "*.md" -exec sed -i 's|- \[Back to Home\](/)|[Back to Home](../../)|g' {} \;
   
   rm -rf content/posts
   rm -rf public/
   rm -rf resources/
   hugo --cleanDestinationDir --verbose
   find content/ -type f -exec sed -i '/troubleshooting/d' {} +
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
    --verbose \
    --gc