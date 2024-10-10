# Base Image will be as below
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
# Install dependencies
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y apache2-utils
# Replace content of Apache Home Page
RUN echo 'This is Docker Image created using Dockerfile!' > /var/www/html/index.html
# Expose Container Port
EXPOSE 80
# Execute command at container launch
CMD ["apache2ctl", "-D", "FOREGROUND"]