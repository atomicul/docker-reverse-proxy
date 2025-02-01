#!/bin/bash

mkdir -p /config/
if [ "$(ls -l /config/ | head -n 1 | awk '{print $2}')"=='0' ]
then
    cp -r /nginx-defaults/* /config/
fi

mkdir -p /config/sites-available/

cat >/config/sites-available/generated <<'EOF'
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
    cat >>/config/sites-available/generated <<EOF
    location $prefix {
        rewrite ^$prefix(.*) /\$1  break;
        proxy_pass $host\$uri\$is_args\$args;
    }
EOF
done

echo '}' >>/config/sites-available/generated

rm -f /config/sites-enabled/generated
ln -sn /config/sites-available/generated /config/sites-enabled/

nginx -c /config/nginx.conf -g 'daemon off;'
