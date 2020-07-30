FROM nginx:stable

COPY app /app

# Upgrade installed packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Python package management and basic dependencies
RUN apt-get install -y curl python3.7 python3.7-dev python3.7-distutils

# Register the version in alternatives
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Set python 3 as the default python
RUN update-alternatives --set python /usr/bin/python3.7

# Upgrade pip to latest version
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py --force-reinstall && \
    rm get-pip.py

RUN pip3 install -r /app/requirements.txt

COPY app/gui /usr/share/nginx/html

RUN /app/setup.sh

RUN apt update && apt install -y libsm6 libxext6
RUN apt-get install -y libxrender-dev

RUN apt-get install -y libglib2.0-0

