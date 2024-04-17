# Use the official NGINX image
FROM nginx:latest

RUN apt update && apt install -y wget

# Download and unpack Geoip database in legacy format from https://www.miyuru.lk/geoiplegacy
RUN cd /var/lib; \
    mkdir -p nginx; \
    wget -q -O- https://dl.miyuru.lk/geoip/maxmind/country/maxmind.dat.gz | gunzip -c > nginx/maxmind-country.dat; \
    wget -q -O- https://dl.miyuru.lk/geoip/maxmind/city/maxmind.dat.gz | gunzip -c > nginx/maxmind-city.dat; \
    chown -R nginx. nginx

# Copy custom config
ADD ./nginx.conf /etc/nginx

# Expose port 80
EXPOSE 80

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]