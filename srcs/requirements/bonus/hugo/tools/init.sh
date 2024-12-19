#!/bin/bash

# Check if Hugo site exists, if not create it
if [ ! -d "/var/www/hugo/site" ]; then
    echo "Creating new Hugo site..."
    hugo new site site
    cd site

    # Use a simpler theme (paper)
    git init
    git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
    echo 'theme = "ananke"' > config.toml

cat >> config.toml <<EOL
baseURL = 'https://${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'My Static Site'

[params]
  background_color_class = "bg-dark-gray"
  featured_image = "/images/gohugo-default-sample-hero-image.jpg"
  recent_posts_number = 2
EOL

    # Create the content directory structure
    mkdir -p content/posts

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
exec hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL=https://${DOMAIN_NAME} \
    --appendPort=false