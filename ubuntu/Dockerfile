FROM ubuntu:18.04

LABEL authors="Konstantin Goretzki, Felix Alexa"
LABEL version="v1.0"
LABEL description="This image contains a working Lychee installation which \
uses the ubuntu base image with nginx and php installed."

ENV TZ=Europe/Berlin
ENV LYCHEE_VERSION v3.1.6
ENV LYCHEE_DOWNLOAD_SHA512 a489257c681c2973ae3683ca0059dddd8c53726c556333804e83c7f4dadfbabe9df363c95d59e12a785e3c1bed78e91930c8490097c963f9b14a1b608b041871

RUN \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
              ca-certificates \
              nginx \
              php \
              php-fpm \
              php-imagick \
              php-mbstring \
              php-exif \
              php-gd \
              php-mysqli \
              php-json \
              php-zip \
              curl \
  && rm -rf /var/lib/apt/lists/* \
  && echo "\ndaemon off;" >> /etc/nginx/nginx.conf \
  && sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf \

  # change php.ini settings for Lychee
  && sed -i -e "s/max_execution_time = 30/max_execution_time = 200/g" /etc/php/7.2/fpm/php.ini \
  && sed -i -e "s/post_max_size = 8M/post_max_size = 100M/g" /etc/php/7.2/fpm/php.ini \
  && echo "upload_max_size = 100M" >> /etc/php/7.2/fpm/php.ini \
  && sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php/7.2/fpm/php.ini \
  && sed -i -e "s/memory_limit = 128M/memory_limit = 256M/g" /etc/php/7.2/fpm/php.ini \

  # remove default html files
  && rm /var/www/html/*

COPY default /etc/nginx/sites-available/default

RUN \
  cd /tmp/ \
  && curl -fSL -o lychee.tar.gz "https://github.com/electerious/Lychee/archive/$LYCHEE_VERSION.tar.gz" \
  && echo "$LYCHEE_DOWNLOAD_SHA512  lychee.tar.gz" | sha512sum -c \
  && tar -xf /tmp/lychee.tar.gz -C /var/www/html --strip-components=1 \
  && rm -rf /tmp/* \
  && chown -R www-data:www-data /var/www/html/*

# define default command
CMD service php7.2-fpm start && nginx

# expose ports
EXPOSE 80

# volumes
VOLUME /var/www/html/uploads /var/www/html/data
