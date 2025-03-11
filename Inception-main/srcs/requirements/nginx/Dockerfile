FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl && \
    mkdir -p /etc/nginx/ssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY tools/my.sh /tmp/my.sh
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /tmp/my.sh

ENTRYPOINT [ "/tmp/my.sh" ]

CMD ["nginx", "-g", "daemon off;"]
