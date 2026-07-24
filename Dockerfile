FROM nginx:1.27-alpine

COPY app/index.html.template /usr/share/nginx/html/index.html.template
COPY app/docker-entrypoint.d/20-envsubst-on-html.sh /docker-entrypoint.d/20-envsubst-on-html.sh

RUN chmod +x /docker-entrypoint.d/20-envsubst-on-html.sh

ENV ENVIRONMENT=unknown
ENV VERSION=unset
ENV BG_COLOR="#333333"

EXPOSE 80
