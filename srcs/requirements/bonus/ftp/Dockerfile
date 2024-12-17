FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y vsftpd && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/vsftpd/empty && \
    mkdir -p /var/www/html

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 21 21100-21110

CMD ["/usr/local/bin/init.sh"]