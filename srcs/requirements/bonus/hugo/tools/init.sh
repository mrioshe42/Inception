#!/bin/bash

# Check if Hugo site exists, if not create it
if [ ! -d "/var/www/hugo/site" ]; then
    echo "Creating new Hugo site..."
    hugo new site site
    cd site

    # Install the Paper theme correctly
    mkdir -p themes/paper
    git clone https://github.com/nanxiaobei/hugo-paper.git themes/paper

    # Create config.toml with logo configuration
    cat > config.toml <<EOL
baseURL = 'https://hugo.${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'My Static Site'
theme = 'paper'

[params]
  # Theme
  color = 'gray'
  darkMode = true
  
  # Logo configuration
  avatar = '/images/42logo.png'
  
  # header social icons
  twitter = ''       
  github = 'mrioshe42'        
  instagram = ''     
  rss = true          

  # home page profile
  name = 'Static Site'
  bio = 'Welcome to my static website built with Hugo!'

  # Theme display
  monoDarkIcon = true
  styleDark = true
EOL

    # Create the content directory structure
    mkdir -p content/posts
    mkdir -p static/images

    # Create a sample post
    cat > content/posts/welcome.md <<EOL
---
title: "Welcome to My Static Site"
date: $(date +%Y-%m-%d)
draft: false
---

## Welcome to my static website!

This site was created using Hugo as part of the 42 school Inception project.

### Features:
- Fast and lightweight
- Static content
- Simple deployment
EOL

    # Initialize git only after creating all files
    git init
    git add .
    git commit -m "Initial commit"
fi

# Start Hugo server
cd /var/www/hugo/site
exec hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL=https://hugo.${DOMAIN_NAME} \
    --appendPort=false