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

    # Ensure static directory exists and copy logo
    mkdir -p static/images
    cp /tmp/42logo.png static/images/

    # Create hugo.toml (main configuration file)
    cat > hugo.toml <<EOL
baseURL = 'https://hugo.${DOMAIN_NAME}'
languageCode = 'en-us'
title = 'My Static Site'
theme = 'paper'

[params]
  # Theme
  color = 'gray'
  darkMode = true
  
  # Logo configuration
  avatar = 'site/static/images/42logo.png'
  
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

[menu]
  [[menu.main]]
    identifier = "about"
    name = "About"
    url = "/about/"
    weight = 10
EOL

    # Remove default config.toml if it exists
    rm -f config.toml

    # Create example content
    mkdir -p content/posts
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

    # Create an about page
    mkdir -p content/about
    cat > content/about/index.md <<EOL
---
title: "About"
date: $(date +%Y-%m-%d)
draft: false
---

## About My Site

This is a static website created using Hugo for the 42 school Inception project.
EOL

    # Commit changes
    git add .
    git commit -m "Initial commit with theme as submodule"
else
    cd site || exit
fi

# Start Hugo server with verbose output
hugo server \
    --bind=0.0.0.0 \
    --port=1313 \
    --baseURL="https://hugo.${DOMAIN_NAME}" \
    --appendPort=false \
    --verbose