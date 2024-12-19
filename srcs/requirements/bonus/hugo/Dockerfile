FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.121.1/hugo_0.121.1_linux-amd64.deb -o hugo.deb \
    && dpkg -i hugo.deb \
    && rm hugo.deb

WORKDIR /var/www/hugo

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 1313

ENTRYPOINT ["/usr/local/bin/init.sh"]