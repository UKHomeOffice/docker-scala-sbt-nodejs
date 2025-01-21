FROM node:20-alpine

RUN export PATH="/usr/local/sbt/bin:$PATH"

RUN apk update

RUN apk add --no-cache openjdk11-jre-headless
RUN apk add --no-cache bash ca-certificates curl tar git protoc

RUN mkdir -p /usr/local/sbt
RUN curl -L "https://github.com/sbt/sbt/releases/download/v1.9.9/sbt-1.9.9.tgz" | tar -xvz -C /usr/local --strip-components=1

RUN addgroup -g 1001 app
RUN adduser -G app -u 1001 -h /app -D app

RUN mkdir -p /drone/src
RUN chown -R app:app /drone

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh
RUN ls -l /app/entrypoint.sh
RUN chown app:app /app/entrypoint.sh
RUN chmod u+x /app/entrypoint.sh

USER app

RUN mkdir -p /app/.sbt
COPY repositories /app/.sbt/repositories

RUN ls -la /app

ENV LANGUAGE=en_GB:en
ENV GDM_LANG=en_GB.utf8
ENV LANG=en_GB.UTF-8

ENV SBT_CREDENTIALS="/app/.ivy2/.credentials"
ENV SBT_OPTS="-Dsbt.override.build.repos=true"
#ENV SBT_CREDENTIALS="/app/.ivy2/.credentials"
#ENV SBT_OPTS="-Duser.home=/app -Dsbt.override.build.repos=true -Dsbt.ivy.home=/app/.ivy2"

ENTRYPOINT ["/app/entrypoint.sh"]
