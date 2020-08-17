FROM php:7.2-apache

COPY image-background-remove-tool/app /app
COPY simple-worker-api /var/www/html

# Upgrade installed packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Install all required packages
RUN apt-get install -y curl python3.7 python3.7-dev python3.7-distutils libsm6 libxext6 libxrender-dev libglib2.0-0 nano sudo

# Don't ask...
RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toto

# Register the version in alternatives
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Set python 3 as the default python
RUN update-alternatives --set python /usr/bin/python3.7

# Upgrade pip to latest version
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py --force-reinstall && \
    rm get-pip.py

RUN pip3 install -r /app/requirements.txt

RUN /app/setup.sh

