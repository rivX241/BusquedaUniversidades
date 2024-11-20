FROM bitnami/minideb:latest

RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    perl \
    libcgi-pm-perl \
    cpanminus \
    && apt-get clean

RUN cpanm CGI

RUN a2enmod cgi

COPY ./cgi-bin/ /usr/lib/cgi-bin/
COPY ./index.html /var/www/html/
COPY ./css/ /var/www/html/css/
COPY ./ProgramasdeUniversidades.csv /usr/lib/cgi-bin/

RUN chmod +x /usr/lib/cgi-bin/universidades.pl

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
