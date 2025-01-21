FROM node:20-alpine

RUN export PATH="/usr/local/sbt/bin:$PATH"

RUN apk update

RUN apk add --no-cache openjdk11-jre-headless
RUN apk add --no-cache bash ca-certificates curl tar git protoc

RUN mkdir -p /usr/local/sbt
RUN curl -L "https://github.com/sbt/sbt/releases/download/v1.9.9/sbt-1.9.9.tgz" | tar -xvz -C /usr/local --strip-components=1

COPY entrypoint.sh /root/entrypoint.sh
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod u+x /root/entrypoint.sh

RUN mkdir -p /root/.sbt
COPY repositories /root/.sbt/repositories

ENV LANGUAGE=en_GB:en
ENV GDM_LANG=en_GB.utf8
ENV LANG=en_GB.UTF-8

ENV SBT_CREDENTIALS="/root/.ivy2/.credentials"
ENV SBT_OPTS="-Dsbt.override.build.repos=true"
#ENV SBT_CREDENTIALS="/root/.ivy2/.credentials"
#ENV SBT_OPTS="-Duser.home=/root -Dsbt.override.build.repos=true -Dsbt.ivy.home=/root/.ivy2"

ENTRYPOINT ["/root/entrypoint.sh"]
