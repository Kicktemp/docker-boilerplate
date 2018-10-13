#++++++++++++++++++++++++++++++++++++++
# PHP application Docker container
#++++++++++++++++++++++++++++++++++++++
#
# PHP-Versions:
#  ubuntu-12.04 -> PHP 5.3         (precise)  LTS
#  ubuntu-14.04 -> PHP 5.5         (trusty)   LTS
#  ubuntu-15.04 -> PHP 5.6         (vivid)
#  ubuntu-15.10 -> PHP 5.6         (wily)
#  ubuntu-16.04 -> PHP 7.0         (xenial)   LTS
#  centos-7     -> PHP 5.4
#  debian-7     -> PHP 5.4         (wheezy)
#  debian-8     -> PHP 5.6 and 7.x (jessie)
#  debian-9     -> PHP 7.0         (stretch)
#
# Apache:
# http://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/apache-dev.html
#
#   webdevops/php-apache-dev:5.6
#   webdevops/php-apache-dev:7.0
#   webdevops/php-apache-dev:7.1
#   webdevops/php-apache-dev:ubuntu-12.04
#   webdevops/php-apache-dev:ubuntu-14.04
#   webdevops/php-apache-dev:ubuntu-15.04
#   webdevops/php-apache-dev:ubuntu-15.10
#   webdevops/php-apache-dev:ubuntu-16.04
#   webdevops/php-apache-dev:centos-7
#   webdevops/php-apache-dev:debian-7
#   webdevops/php-apache-dev:debian-8
#   webdevops/php-apache-dev:debian-8-php7
#   webdevops/php-apache-dev:debian-9
#
# Nginx:
# http://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/nginx-dev.html
#
#   webdevops/php-nginx-dev:5.6
#   webdevops/php-nginx-dev:7.0
#   webdevops/php-nginx-dev:7.1
#   webdevops/php-nginx-dev:ubuntu-12.04
#   webdevops/php-nginx-dev:ubuntu-14.04
#   webdevops/php-nginx-dev:ubuntu-15.04
#   webdevops/php-nginx-dev:ubuntu-15.10
#   webdevops/php-nginx-dev:ubuntu-16.04
#   webdevops/php-nginx-dev:centos-7
#   webdevops/php-nginx-dev:debian-7
#   webdevops/php-nginx-dev:debian-8
#   webdevops/php-nginx-dev:debian-8-php7
#   webdevops/php-nginx-dev:debian-9
#
# HHVM:
#   webdevops/hhvm-apache
#   webdevops/hhvm-nginx
#
#++++++++++++++++++++++++++++++++++++++

FROM webdevops/php-apache-dev:ubuntu-16.04

ENV PROVISION_CONTEXT "development"

# Deploy scripts/configurations
COPY etc/       /opt/docker/etc/

RUN apt-install ssmtp mysql-client vim
RUN ln -sf /opt/docker/etc/php/development.ini /opt/docker/etc/php/php.ini
RUN ln -sf /opt/docker/etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf

# Configure volume/workdir
WORKDIR /app/
