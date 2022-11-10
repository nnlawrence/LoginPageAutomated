FROM ruby:latest


# Add google chrome apt source
RUN curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list

# Install required apt packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	google-chrome-stable \
	libkrb5-dev \
	python \
	python3-pip \
	unzip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Install chromedriver
RUN curl -o /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip \
	&& unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ \
	&& rm /tmp/chromedriver.zip

# set display port to avoid crash
ENV DISPLAY=:99

RUN bundle config --global frozen 1

WORKDIR /gems
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN NOKOGIRI_USE_SYSTEM_LIBRARIES=true bundle install
WORKDIR /app
ADD . /app 
ENV LANG C.UTF-8

# Install MX certificates
ADD tools/mx_internal_root_ca.pem /usr/local/share/ca-certificates/mx_internal_root_ca.crt
RUN chmod 644 /usr/local/share/ca-certificates/mx_internal_root_ca.crt && update-ca-certificates

ENV APP_DIR /app
