#!/bin/bash

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
        proxy_pass $host\$uri\$is_args\$args;
    }
EOF
done

echo '}' >>/etc/nginx/sites-enabled/default

nginx -g 'daemon off;'
