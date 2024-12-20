FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global init.defaultBranch main && \
    git config --global user.email "hugo@42.fr" && \
    git config --global user.name "Hugo Site"

RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.121.1/hugo_0.121.1_linux-amd64.deb -o hugo.deb \
    && dpkg -i hugo.deb \
    && rm hugo.deb

WORKDIR /var/www/hugo

RUN rm -rf site

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

COPY tools/static/images/* /tmp/

EXPOSE 1313

ENTRYPOINT ["/usr/local/bin/init.sh"]