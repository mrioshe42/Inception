#!/bin/bash

# Create new Hugo site if it doesn't exist
if [ ! -d "/var/www/hugo/site" ]; then
    echo "Creating new Hugo site..."
    hugo new site site
    cd site || exit

    # Initialize git repository
    git init
    git config --global --add safe.directory /var/www/hugo/site

    # Install the Paper theme as a submodule
    git submodule add https://github.com/nanxiaobei/hugo-paper.git themes/paper
    git submodule init
    git submodule update

    # Create necessary directories
    mkdir -p static/images
    mkdir -p content/{posts,docs}

    # Copy logo and other images
    cp /tmp/42logo.png static/images/
    cp /tmp/docker-diagram.png static/images/
    cp /tmp/nginx-config.png static/images/
    cp /tmp/wordpress-setup.png static/images/

    # Create hugo.toml with better structure
    cat > hugo.toml <<EOL
baseURL = 'https://hugo.${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'Inception'
theme = 'paper'

[params]
  color = 'gray'
  darkMode = true
  
  # Logo configuration
  avatar = '/images/42logo.png'
  
  # header social icons
  github = 'mrioshe42'        
  rss = true          

  # home page profile
  name = 'Inception Project Documentation'
  bio = 'A comprehensive guide to the 42 school Inception project'

  # Theme display
  monoDarkIcon = true
  styleDark = true

[menu]
  [[menu.main]]
    identifier = "overview"
    name = "Overview"
    url = "/posts/overview/"
    weight = 10
    
  [[menu.main]]
    identifier = "services"
    name = "Services"
    url = "/docs/services/"
    weight = 20
    
  [[menu.main]]
    identifier = "setup"
    name = "Setup Guide"
    url = "/docs/setup/"
    weight = 30
    
  [[menu.main]]
    identifier = "troubleshooting"
    name = "Troubleshooting"
    url = "/docs/troubleshooting/"
    weight = 40
EOL

    # Create overview post
    cat > content/posts/overview.md <<EOL
---
title: "Inception Project Overview"
date: $(date +%Y-%m-%d)
draft: false
---

## Welcome to the Inception Project Guide

The Inception project at 42 school is a DevOps-focused project that introduces system administration concepts using Docker. This project involves setting up a small infrastructure composed of different services under specific rules.

![Docker Infrastructure](/images/docker-diagram.png)

### Project Objectives

- Learn about containerization using Docker
- Understand Docker Compose for multi-container applications
- Configure NGINX with TLS/SSL
- Set up WordPress with PHP-FPM
- Implement MariaDB database
- Create additional services (Redis, FTP, etc.)
- Work with Docker volumes and networks

### Key Components

1. **NGINX Container**
   - Acts as a reverse proxy
   - Handles SSL/TLS termination
   - Serves static content

2. **WordPress Container**
   - Runs PHP-FPM
   - Hosts the WordPress application
   - Connects to MariaDB

3. **MariaDB Container**
   - Provides the database backend
   - Persists data using volumes
   - Secure configuration

4. **Additional Services**
   - Redis cache
   - Static website using Hugo
   - FTP server
   - Adminer/phpMyAdmin
EOL

    # Create services documentation
    cat > content/docs/services.md <<EOL
---
title: "Services Documentation"
draft: false
---

## Docker Services Configuration

### NGINX Configuration
\`\`\`nginx
# Example NGINX configuration
server {
    listen 443 ssl;
    server_name ${DOMAIN_NAME};
    
    ssl_certificate /etc/nginx/ssl/inception.crt;
    ssl_certificate_key /etc/nginx/ssl/inception.key;
    
    root /var/www/wordpress;
    index index.php;
    
    # Additional configuration...
}
\`\`\`

![NGINX Configuration](/images/nginx-config.png)

### WordPress Setup
- PHP-FPM configuration
- WordPress initialization
- Plugin management
- Security considerations

![WordPress Setup](/images/wordpress-setup.png)

### MariaDB Configuration
\`\`\`sql
-- Database initialization
CREATE DATABASE wordpress;
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';
FLUSH PRIVILEGES;
\`\`\`
EOL

    # Create setup guide
    cat > content/docs/setup.md <<EOL
---
title: "Setup Guide"
draft: false
---

## Project Setup Instructions

### Prerequisites
- Docker and Docker Compose installed
- Basic understanding of Linux commands
- Domain name configuration
- SSL certificate generation

### Step-by-Step Guide

1. **Clone the Repository**
   \`\`\`bash
   git clone https://github.com/mrioshe42/Inception.git
   cd Inception
   \`\`\`

2. **Configure Environment Variables**
   \`\`\`bash
   cp .env.example .env
   # Edit .env with your settings
   \`\`\`

3. **Build and Start Services**
   \`\`\`bash
   make build
   make up
   \`\`\`

4. **Verify Installation**
   \`\`\`bash
   make ps
   make logs
   \`\`\`
EOL

    # Create troubleshooting guide
    cat > content/docs/troubleshooting.md <<EOL
---
title: "Troubleshooting Guide"
draft: false
---

## Common Issues and Solutions

### Docker Container Issues
- Container won't start
- Network connectivity problems
- Volume mounting issues

### WordPress Problems
- Database connection errors
- PHP configuration issues
- Plugin conflicts

### SSL/TLS Certificate Issues
- Certificate validation errors
- SSL handshake failures
- Certificate renewal problems

### Performance Optimization
- Cache configuration
- Database optimization
- NGINX tuning
EOL

    # Commit changes
    git add .
    git commit -m "Initial commit with comprehensive documentation"
else
    cd site || exit
fi

# Start Hugo server
hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL="https://hugo.${DOMAIN_NAME}" \
    --appendPort=false