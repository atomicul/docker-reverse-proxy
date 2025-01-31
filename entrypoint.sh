#!/bin/bash

line_number=$(
    grep -m 1 -nE '^http\s*{' < /etc/nginx/nginx.conf |
    awk -F ':' '{print $1}'
)

sed -i "$line_number a resolver 127.0.0.11;" /etc/nginx/nginx.conf

cat >/etc/nginx/sites-enabled/default <<'EOF'
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
    cat >>/etc/nginx/sites-enabled/default <<EOF
    location $prefix {
        rewrite ^$prefix(.*) /\$1  break;
        # this set prevents some dns caching issues when used with docker-compose
        # set \$target $host\$uri\$is_args\$args;
        proxy_pass $host\$uri\$is_args\$args;
    }
EOF
done

echo '}' >>/etc/nginx/sites-enabled/default

nginx -g 'daemon off;'
