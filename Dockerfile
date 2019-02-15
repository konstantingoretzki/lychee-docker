FROM nginx:1.15.8-alpine

LABEL authors="Konstantin Goretzki, Felix Alexa"
LABEL version="v1.7"
LABEL description="This image contains a working Lychee installation which \
uses the nginx:1.15.8-alpine image. The base images provides alpine with nginx installed, \
we've added php7 and the lychee files. We've tried to do everything as small, secure and clean \
as possible, but if you find some spots which need to be improved, feel free to tell us."

# set timezone, version and hash of Lychee download
ARG TZ=Europe/Berlin
ARG LYCHEE_VERSION=v3.2.11
ARG LYCHEE_DOWNLOAD_SHA512=129781c8ff3b955b5a68e2e5d87e387c18838ffca0c17210a3247517ce422e23a65f93b2632ace3a618dceb6af65987427255cc35c507e8d66070a68444bb5ce

# set timezone and install php7 and required php-modules
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apk update \
    && apk add --no-cache php7 \
          php7-fpm \
          php7-imagick \
          php7-mbstring \
          php7-exif \
          php7-gd \
          php7-mysqli \
          php7-json \
          php7-zip \
          php7-session \
          supervisor \
          imagemagick \
          curl 
          
# change php.ini and php-fpm settings for Lychee
RUN \
  sed -i -e "s/max_execution_time = 30/max_execution_time = 200/g" /etc/php7/php.ini \
  && sed -i -e "s/post_max_size = 8M/post_max_size = 100M/g" /etc/php7/php.ini \
  && echo "upload_max_size = 100M" >> /etc/php7/php.ini \
  && sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php7/php.ini \
  && sed -i -e "s/memory_limit = 128M/memory_limit = 256M/g" /etc/php7/php.ini \
  && sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = nginx|g" /etc/php7/php-fpm.d/www.conf \
  && sed -i "s|;listen.group\s*=\s*nobody|listen.group = nginx|g" /etc/php7/php-fpm.d/www.conf \
  && sed -i "s|user\s*=\s*nobody|user = nginx|g" /etc/php7/php-fpm.d/www.conf \
  && sed -i "s|group\s*=\s*nobody|group = nginx|g" /etc/php7/php-fpm.d/www.conf

# remove default nginx files, download + verify v.3.2.8 Lychee release and copy them to the webroot
RUN \
  rm -r /usr/share/nginx/html/* \
  && cd /tmp/ \
  && curl -fSL -o lychee.tar.gz "https://github.com/LycheeOrg/Lychee/archive/$LYCHEE_VERSION.tar.gz" \
  && echo "$LYCHEE_DOWNLOAD_SHA512  lychee.tar.gz" | sha512sum -c \
  && tar -xf /tmp/lychee.tar.gz -C /usr/share/nginx/html/ --strip-components=1 \
  && rm -rf /tmp/* \
  && chown -R nginx:nginx /usr/share/nginx/html/*

# copy nginx and supervisor config-files
COPY src/nginx.conf /etc/nginx/nginx.conf
COPY src/supervisord.conf /etc/supervisord.conf

# expose port
EXPOSE 80

STOPSIGNAL SIGTERM

# volumes
VOLUME /usr/share/nginx/html/uploads /usr/share/nginx/html/data

# start supervisord which manages the nginx and php-fpm processes
CMD /usr/bin/supervisord -n -c /etc/supervisord.conf
