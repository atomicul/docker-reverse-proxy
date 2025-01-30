FROM ubuntu:22.04
EXPOSE 80
RUN apt-get update -qq && \
    apt-get install -y -qq nginx
COPY entrypoint.sh /bin
RUN chmod +x /bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
