FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN apt update \
    && apt install -y \
        curl \
        git \
        php \
        zip \
        unzip \
        php-zip \
        apache2 \
        libapache2-mod-php \
        cron \
        vim \
        at \
    && curl -sS https://getcomposer.org/installer | php \
    && php composer.phar create-project cronkeep/cronkeep --keep-vcs -s dev /var/www/cronkeep \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    # Fix Bug
    && sed -i 's/sh -c "echo "%s" | at now"/echo "%s" | at now/g' /var/www/cronkeep/src/application/models/Crontab.php \
    && sed -i 's/$process->start()/$process->run()/g' /var/www/cronkeep/src/application/models/Crontab.php \
    && sed -i 's/$process = new Process($command);/$command = str_replace("\\%", "%", $command);$process = new Process($command);/g' /var/www/cronkeep/src/application/models/Crontab.php \
    # Give User Crontab Permission
    && sed -i '/^www-data/d' /etc/at.deny \
    && echo "www-data" >> /etc/at.allow \
    # Set Apache Config
    && echo '<VirtualHost *:80>\n\
        ServerName cronkeep \n\
        ServerAlias * \n\
        DocumentRoot /var/www/cronkeep/src\n\
        \n\
        <Directory "/var/www/cronkeep/src">\n\
            AllowOverride all\n\
            DirectoryIndex index.html index.php \n\
        </Directory>\n\
    </VirtualHost>' > /etc/apache2/sites-available/cronkeep.conf \
    && a2enmod rewrite \
    && a2ensite cronkeep \
    # Deal Permission Stuff
    && chgrp crontab /usr/bin/crontab \
    && chmod 2755 /usr/bin/crontab \
    && chmod 777 -R /var/spool/cron \
    && usermod -aG root www-data \
    && usermod -aG crontab www-data \
    && chown www-data /home \
    && chgrp www-data /home

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80

CMD tail -f /dev/null
