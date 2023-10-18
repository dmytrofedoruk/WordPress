# We will use PHP official image with Apache
FROM php:7.4-apache

# Set ServerName for Apache to suppress warning messages
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    libzip-dev \
    unzip

# Install PHP extensions
RUN docker-php-ext-install mysqli opcache zip

# Download WordPress
RUN curl -O https://wordpress.org/latest.tar.gz

# Extract WordPress
RUN tar xzvf latest.tar.gz \
    && cp -a wordpress/. /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf wordpress latest.tar.gz

# Change the working directory to Apache’s www directory
WORKDIR /var/www/html

# Expose port 80 for the app
EXPOSE 80

# Start the server
CMD ["apache2-foreground"]
