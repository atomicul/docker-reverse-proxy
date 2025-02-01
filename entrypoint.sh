#!/bin/bash

mkdir -p /nginx/
if [ "$(ls -l /nginx/ | head -n 1 | awk '{print $2}')"=='0' ]
then
    cp -r /nginx-defaults/* /nginx/
fi

mkdir -p /nginx/sites-available/

cat >/nginx/sites-available/generated <<'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name _;
EOF

for i in "$@"
do
    pair=($i)
    prefix="${pair[0]}"
    host="${pair[1]}"
    cat >>/nginx/sites-available/generated <<EOF
    location $prefix {
        rewrite ^$prefix(.*) /\$1  break;
        proxy_pass $host\$uri\$is_args\$args;
    }
EOF
done

echo '}' >>/nginx/sites-available/generated

nginx -c /nginx/nginx.conf -g 'daemon off;'
