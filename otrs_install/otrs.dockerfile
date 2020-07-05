FROM ubuntu:18.04

ENV OTRS_VERSION=6.0.23

COPY after_install.sh /root/

RUN apt-get update && apt-get install -y \ 
    wget \
    nano \
    make \
    perl \
    cpanminus \
    apache2 \
    cron \
    libdigest-md5-perl \
    libapache2-mod-perl2 \
    libdatetime-perl \
    libcrypt-ssleay-perl \
    libtimedate-perl \
    libnet-dns-perl \
    libnet-ldap-perl \
    libio-socket-ssl-perl \
    libpdf-api2-perl \
    libdbd-mysql-perl \
    libsoap-lite-perl \
    libtext-csv-xs-perl \
    libjson-xs-perl \
    libapache-dbi-perl \
    libxml-libxml-perl \
    libxml-libxslt-perl \
    libyaml-perl \
    libarchive-zip-perl \
    libcrypt-eksblowfish-perl \
    libencode-hanextra-perl \
    libmail-imapclient-perl \
    libtemplate-perl \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q http://ftp.otrs.org/pub/otrs/otrs-${OTRS_VERSION}.tar.gz

RUN tar -zxf otrs-${OTRS_VERSION}.tar.gz; \
    mv otrs-${OTRS_VERSION} /opt/otrs; \
    rm otrs-${OTRS_VERSION}.tar.gz

RUN useradd -d /opt/otrs/ -c 'OTRS user' otrs; \
    usermod -G www-data otrs

RUN cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm; \
    sed -i 's/127\.0\.0\.1/172\.21\.0\.3/' /opt/otrs/Kernel/Config.pm

RUN ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/sites-enabled/zzz_otrs.conf; \
    for i in perl deflate filter headers; do a2enmod ${i}; done; \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf; \
    service apache2 restart

RUN /opt/otrs/bin/otrs.SetPermissions.pl

RUN cd /opt/otrs/var/cron/ && for foo in *.dist; do cp $foo `basename $foo .dist`; done; \
    su - otrs -c "/opt/otrs/bin/Cron.sh start"

RUN for icpan in Log::Log4perl JSON REST:Client; do yes | cpan ${icpan}; done;

ENTRYPOINT [ "apache2ctl" ]
CMD [ "-D", "FOREGROUND" ]