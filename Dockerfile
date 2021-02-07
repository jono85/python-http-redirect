FROM ubuntu:latest

#ARG is only available during docker build, whereas ENV would be available also in docker run
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ='Europe/Dublin'

RUN apt-get update && apt-get -y install python3 python3-pip --no-install-recommends
RUN pip3 install gunicorn flask

COPY .bashrc /root/
COPY app /app
RUN chmod +x /app/*.sh

#ENV TZ='Europe/Dublin'

ENV THREADS_COUNT=2
ENV REQUEST_TIMEOUT=30
ENV SERVER_PORT=80
ENV USE_SELF_SIGNED_SSL='false'
ENV REAL_IP_HEADER_NAME='not-set'
ENV DEFAULT_REDIRECT='https://www.google.com/'
ENV REDIRECT_CONFIG='{"some.domain.com":"https://redirected.address.com/"}'

WORKDIR /app

#expose default ports, for others the docker container must be launched with the parameter to expose/publish them
EXPOSE 80
EXPOSE 443

ENTRYPOINT /app/entrypoint.sh
