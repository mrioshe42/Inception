#!/bin/bash

# Check if Hugo site exists, if not create it
if [ ! -d "/var/www/hugo/site" ]; then
    echo "Creating new Hugo site..."
    hugo new site site
    cd site

    # Install the Paper theme correctly
    git init
    # Clone the paper theme directly into themes directory
    git clone https://github.com/nanxiaobei/hugo-paper themes/paper

    # Create hugo.toml with correct theme configuration
    cat > hugo.toml <<EOL
baseURL = 'https://${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'My Static Site'
theme = 'paper'

[params]
  # color style
  color = 'gray'                           # linen, wheat, gray, light

  # header social icons
  twitter = ''       
  github = 'mrioshe42'        
  instagram = ''     
  rss = true          

  # home page profile
  avatar = ''                 
  name = 'Static Site'
  bio = 'Welcome to my static website built with Hugo!'

  # misc
  disableHLJS = true                      # disable highlight.js
  monoDarkIcon = true                     # show monochrome dark mode icon
EOL

    # Create the content directory structure
    mkdir -p content/posts

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
fi

# Start Hugo server with proper configuration
cd /var/www/hugo/site
exec hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL=https://${DOMAIN_NAME} \
    --appendPort=false \
    --themesDir themes \
    --theme paper