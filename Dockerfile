# Based on nginx alpine image
FROM wailinoo/php-nginx-laravel:2.0

# Set workdir to www
WORKDIR /var/www

# Copy laravel files
COPY laravel-app/ .

#RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
#RUN apt-get update
#RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
#RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
#RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
#RUN . ~/.bashrc
#RUN apt-get install -y unixodbc-dev \
#                      libgssapi-krb5-2
# Configure laravel app
RUN php -r "file_exists('.env') || copy('.env.example', '.env');"
RUN composer install
RUN php artisan key:generate
RUN chown -R nobody:nogroup /var/www/storage
RUN chmod -R 777 storage bootstrap/cache

# Define arguments
ARG DB_HOST
ARG DB_DATABASE
ARG DB_USERNAME
ARG DB_PASSWORD

# Set Env Variables
ENV DB_CONNECTION=mysql
ENV DB_HOST=mysqldbinstance.cp480geljvmp.us-east-1.rds.amazonaws.com
ENV DB_PORT=3306
ENV DB_DATABASE=mydb
ENV DB_USERNAME=admin
ENV DB_PASSWORD=1LhRzUXf3AgCAGX4

# clear environment config cache
RUN php artisan config:cache

EXPOSE 80
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
