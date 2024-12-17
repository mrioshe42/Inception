FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    hugo \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/hugo

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 1313

ENTRYPOINT ["/usr/local/bin/init.sh"]