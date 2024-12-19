#!/bin/bash

# Check if Hugo site exists, if not create it
if [ ! -d "/var/www/hugo/site" ]; then
    echo "Creating new Hugo site..."
    hugo new site site
    cd site

    # Use a simpler theme (paper)
    git init
    git submodule add https://github.com/nanxiaobei/hugo-paper themes/paper
    echo 'theme = "paper"' > config.toml
    
    # Add basic configuration
    cat >> config.toml <<EOL
baseURL = 'https://${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'My Static Site'
theme = 'paper'

[params]
  # color style
  color = 'linen'                           # linen, wheat, gray, light

  # header social icons
  twitter = ''       # twitter.com/YOUR_TWITTER_ID
  github = ''        # github.com/YOUR_GITHUB_ID
  instagram = ''     # instagram.com/YOUR_INSTAGRAM_ID
  rss = ''          # true or false

  # home page profile
  avatar = ''                 # gravatar email or image url
  name = 'Static Site'
  bio = 'Welcome to my static website built with Hugo!'
EOL

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