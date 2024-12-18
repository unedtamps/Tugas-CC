FROM alpine:latest

RUN apk update && apk add --no-cache \
  nginx \
  supervisor

RUN apk --no-cache add libc6-compat

WORKDIR /app

COPY ./web/backend/hasil /app/hasil
COPY ./web/backend/public /app/public
COPY ./web/backend/.env /app/.env


RUN rm -rf /var/www/html/*
COPY ./web/frontend/ /var/www/html/

COPY ./certs/project.crt /etc/nginx/ssl/nginx-selfsigned.crt
COPY ./certs/project.key /etc/nginx/ssl/nginx-selfsigned.key

COPY nginx.conf /etc/nginx/http.d/default.conf

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
