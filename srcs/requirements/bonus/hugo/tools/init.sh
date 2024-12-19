#!/bin/bash

# Check if Hugo site exists, if not create it
if [ ! -d "/var/www/hugo/site" ]; then
    hugo new site site
    cd site

    # Install the Paper theme correctly
    git init
    git clone https://github.com/nanxiaobei/hugo-paper themes/paper

    mkdir -p static/images
    cp /42/git_inception/srcs/requirements/bonus/hugo/tools/static/images/42logo.png site/static/images/

    # Create hugo.toml with dark theme configuration
    cat > hugo.toml <<EOL
baseURL = 'https://hugo.${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'Inception'
theme = 'paper'

[params]
  # Theme
  color = 'gray'
  
  # Dark mode
  defaultTheme = "dark"
  
  # Logo configuration
  avatar = 'site/static/images/42logo.png'

  # header social icons
  twitter = ''       
  github = 'mrioshe42'        
  instagram = ''     
  rss = true          

  # home page profile
  name = 'Static Site'
  bio = 'Welcome !'

  # Other settings
  monoDarkIcon = true
  fullWidthTheme = true
  centerTheme = true
EOL

    # Create the content directory structure
    mkdir -p content/posts

    # Create a sample post
    cat > content/posts/welcome.md <<EOL
---
title: "Welcome !"
date: 2024-12-19
draft: false
---

## Welcome to my static website!

This site was created using Hugo as part of the 42 school Inception project.

### Features:
- Fast and lightweight
- Static content
- Simple deployment
EOL
fi

# Start Hugo server
cd /var/www/hugo/site
exec hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL=https://hugo.${DOMAIN_NAME} \
    --appendPort=false \
    --themesDir themes \
    --theme paper