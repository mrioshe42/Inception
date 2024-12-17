FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    fail2ban \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mrios-he.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy fail2ban configuration
COPY conf/jail.local /etc/fail2ban/jail.local
COPY conf/nginx-badbots.conf /etc/fail2ban/filter.d/nginx-badbots.conf
COPY conf/wordpress.conf /etc/fail2ban/filter.d/wordpress.conf

RUN mkdir -p /var/run/nginx /var/log/nginx

EXPOSE 443

# Start both nginx and fail2ban
COPY tools/start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]