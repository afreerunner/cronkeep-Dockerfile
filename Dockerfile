FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN apt update && apt install -y curl git php zip unzip php-zip apache2 libapache2-mod-php cron vim at
RUN curl -sS https://getcomposer.org/installer | php

RUN php composer.phar create-project cronkeep/cronkeep --keep-vcs -s dev /var/www/cronkeep

# Fix Bug
RUN sed -i 's/sh -c "echo "%s" | at now"/echo "%s" | at now/g' /var/www/cronkeep/src/application/models/Crontab.php
RUN sed -i 's/$process->start()/$process->run()/g' /var/www/cronkeep/src/application/models/Crontab.php
# Optimize Code
RUN sed -i 's/$process = new Process($command);/$command = str_replace("\\%", "%", $command);$process = new Process($command);/g' /var/www/cronkeep/src/application/models/Crontab.php

# Give User Crontab Permission
RUN sed -i '/^www-data/d' /etc/at.deny
RUN echo "www-data" >> /etc/at.allow

RUN echo '<VirtualHost *:80>\n\
    ServerName cronkeep \n\
    ServerAlias * \n\
    DocumentRoot /var/www/cronkeep/src\n\
    \n\
    <Directory "/var/www/cronkeep/src">\n\
        AllowOverride all\n\
        DirectoryIndex index.html index.php \n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/cronkeep.conf

RUN a2enmod rewrite
RUN a2ensite cronkeep

RUN chgrp crontab /usr/bin/crontab
RUN chmod 2755 /usr/bin/crontab

RUN chmod 777 -R /var/spool/cron

RUN usermod -aG root www-data
RUN usermod -aG crontab www-data

RUN chown www-data /home
RUN chgrp www-data /home

# Do Image Clean Job
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80

CMD tail -f /dev/null
