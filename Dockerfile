## Modified by Sam KUON - /05/17
FROM centos:latest
MAINTAINER Sam KUON "sam.kuonssp@gmail.com"

# System timezone
ENV TZ=Asia/Phnom_Penh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install repository, packages and update as needed
RUN yum -y install epel-release https://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm && \
    yum clean all && \
    yum -y update && \
    yum -y install mod_php70u \
                   php70u-common \
                   php70u-fpm \
                   php70u-mcrypt \
                   php70u-pear \
                   php70u-pdo \
                   php70u-mbstring \
                   php70u-ldap \
                   php70u-cli \
                   php70u-gd \
                   php70u-opcache \
                   php70u-json \
                   php70u-posix \
                   php70u-mysqlnd

# Copy standard PHP configuration
ADD ./conf.d/phpdefault.ini /etc/php.d/phpdefault.ini
ADD ./conf.d/phpdefault-www.conf /etc/php-fpm.d/phpdefault-www.conf
ADD ./conf.d/phpdefault.conf /etc/php-fpm.d/phpdefault.conf

# PHP configuration
RUN sed -e 's/^\(include.*\)/;moved to end of the file\n;\1/' -i /etc/php-fpm.conf && \
    echo 'include=/etc/php-fpm.d/*.conf' >> /etc/php-fpm.conf && \
    sed -i 's/^/;/' /etc/php-fpm.d/www.conf && \
	mkdir -p /srv/www

# PHP Listen port
EXPOSE 9000

# PHP Auto startup
ENTRYPOINT /usr/sbin/php-fpm --nodaemonize
