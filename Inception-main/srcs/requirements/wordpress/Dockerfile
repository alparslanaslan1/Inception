# Debian Bullseye tabanlı bir imaj kullanıyoruz
FROM debian:bullseye

# Sistem paketlerini güncelliyoruz ve gerekli paketleri yüklüyoruz
RUN apt-get update && apt-get install -y php7.4-fpm php7.4-mysql wget mariadb-client

# WordPress’in e-posta servisini kullanmasını engelliyoruz
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/sendmail && chmod +x /usr/sbin/sendmail

# WP-CLI (WordPress Komut Satırı Aracı) yükleniyor
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp-cli

# WordPress'in çalışacağı dizini oluşturuyoruz
RUN mkdir -p /var/www/html----

# PHP-FPM yapılandırmasını kopyalıyoruz
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# Gerekli kurulum betiklerini kopyalıyoruz ve çalıştırılabilir hale getiriyoruz
COPY ./tools /
RUN chmod +x /entrypoint.sh

# Çalışma dizini olarak WordPress'in bulunduğu klasörü belirliyoruz
WORKDIR /var/www/html

# Konteyner çalıştırıldığında önce WordPress giriş noktası (entrypoint) çalıştırılıyor
ENTRYPOINT [ "/entrypoint.sh" ]

# PHP-FPM başlatılıyor (Arka planda çalışmasını engelleyerek logları izleyebiliriz)
CMD ["/usr/sbin/php-fpm7.4", "--nodaemonize"]
