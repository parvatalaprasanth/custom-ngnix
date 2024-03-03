# Use the official NGINX image
FROM nginx:latest

# # delete later
# RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*

# # Copy a custom configuration file from the current directory
# COPY nginx.conf /etc/nginx/nginx.conf

# # Expose port 80 to the outside world
# EXPOSE 80

# # Command to start NGINX when the container starts
# CMD ["nginx", "-g", "daemon off;"]

# # docker build -t ngnix-dev  . && docker run -p 3000:80 ngnix-dev
# # docker run -p 3000:80 ngnix-dev
##=====================================================
# Install build tools and GeoIP database
# RUN apt-get update && apt-get install -y \
#     libmaxminddb0 \
#     libmaxminddb-dev \
#     wget

# COPY GeoLite2-City.tar.gz .

# # RUN tar -xzf GeoLite2-City.tar.gz
# RUN tar -xzf GeoLite2-City.tar.gz && \
#     mv GeoLite2-City_20191029 /usr/share/GeoIP/

# # Copy a custom configuration file from the current directory
# COPY nginx.conf /etc/nginx/nginx.conf

# # Expose port 80 to the outside world
# EXPOSE 80

# # Command to start NGINX when the container starts
# CMD ["nginx", "-g", "daemon off;"]

##================================

# Install required packages for building NGINX
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    libgeoip-dev git libmaxminddb0 libmaxminddb-dev mmdb-bin \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    dpkg-dev \
    git \
    libssl-dev \
    libpcre3-dev \
    zlib1g-dev \
    wget \
    unzip

COPY GeoLite2-City.tar.gz .

# RUN tar -xzf GeoLite2-City.tar.gz
RUN tar -xzf GeoLite2-City.tar.gz && \
    mv GeoLite2-City_20191029 /usr/share/GeoIP/

# Download and extract NGINX source
RUN wget http://nginx.org/download/nginx-1.25.4.tar.gz && \
    tar -zxvf nginx-1.25.4.tar.gz && \
    rm nginx-1.25.4.tar.gz

RUN git clone https://github.com/leev/ngx_http_geoip2_module /usr/src/ngx_http_geoip2_module


# # Configure NGINX with the GeoIP module
# Configure NGINX with GeoIP module
RUN cd nginx-1.25.4 && \
    ./configure --with-compat --add-dynamic-module=/usr/src/ngx_http_geoip2_module && \
    make modules


RUN cp /nginx-1.25.4/objs/ngx_http_geoip2_module.so /usr/lib/nginx/modules

# Copy NGINX conflsiguration file with GeoIP configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]

# find / -type d -name "configure"./configure --add-dynamic-module=/usr/src/ngx_http_geoip2_module --without-http_rewrite_module 
# 