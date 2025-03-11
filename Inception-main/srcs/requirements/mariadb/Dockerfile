FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/setup-mysql.sh /

RUN chmod +x /setup-mysql.sh
ENTRYPOINT [ "/setup-mysql.sh" ]
CMD [ "mariadbd" ]

