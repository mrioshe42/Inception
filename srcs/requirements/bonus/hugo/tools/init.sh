#!/bin/bash

# Check if Hugo site exists, if not create it
if [ ! -d "/var/www/hugo/site" ]; then
    echo "Creating new Hugo site..."
    hugo new site site
    cd site

    # Initialize git and add theme
    git init
    git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
    echo "theme = 'ananke'" >> config.toml

    # Create a sample post
    hugo new posts/welcome.md
    
    # Edit the welcome post
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

# Start Hugo server
cd /var/www/hugo/site
hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL=https://${DOMAIN_NAME} \
    --appendPort=false