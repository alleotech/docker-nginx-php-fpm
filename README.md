# Docker image for nginx and php-fpm in single container

```docker exec -p 80:80 alleotech/nginx-php```

## Handy Paths

* nginx include: /etc/nginx/conf.d/*/*.conf
* nginx vhosts' webroots: /var/www/html/<domain>/webroot/
* nginx logs: /var/log/nginx/

Ideally the above ones should be mounted from docker host
and container nginx configuration (see vhost.conf for example),
site files and place to right logs to.

Both php-fpm and nginx run under nobody inside the container

Exposes port 80 for nginx.
