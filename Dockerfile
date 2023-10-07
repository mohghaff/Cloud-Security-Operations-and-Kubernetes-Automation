FROM nginx:alpine
LABEL maintainer="Mohsen Ghaffari <m.ghaffari.k@gmail.com"

COPY ./website /website
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80