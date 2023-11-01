FROM node:20-alpine


ENV SCALA_VERSION=2.13.12 \
    SCALA_HOME=/usr/share/scala

# NOTE: bash is used by scala/scalac scripts, and it cannot be easily replaced with ash.
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    apk add --no-cache bash curl jq && \
    cd "/tmp" && \
    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    apk del .build-dependencies && \
    rm -rf "/tmp/"*

#RUN export PATH="/usr/local/sbt/bin:$PATH"
RUN apk update && apk add ca-certificates wget tar openjdk17-jre-headless
RUN mkdir -p "/usr/local/sbt" && wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v1.7.2/sbt-1.7.2.tgz" | tar xz -C /usr/local --strip-components=1
RUN sbt -Dsbt.rootdir=true sbtVersion

RUN addgroup -g 1001 app
RUN adduser -G app -u 1001 -h /app -D app
RUN mkdir -p /app
RUN chown -R app:app /app

WORKDIR /app

RUN mkdir -p /app/.sbt /app/.ivy2

ENV LANGUAGE=en_GB:en
ENV GDM_LANG=en_GB.utf8
ENV LANG=en_GB.UTF-8
ENV SBT_CREDENTIALS="/app/.ivy2/.credentials"
ENV SBT_OPTS="-Duser.home=/app -Dsbt.override.build.repos=true -Dsbt.ivy.home=/app/.ivy2"
