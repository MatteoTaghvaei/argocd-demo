#!/bin/sh
set -e

envsubst '${ENVIRONMENT} ${VERSION} ${BG_COLOR}' \
  < /usr/share/nginx/html/index.html.template \
  > /usr/share/nginx/html/index.html
