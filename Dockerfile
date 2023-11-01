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


RUN groupadd -r app -g 1000 && \
    useradd -r -g app -u 1000 app -d /app && \
    mkdir -p /app && \
    chown -R app:app /app

WORKDIR /app

RUN wget https://github.com/sbt/sbt/releases/download/v1.7.2/sbt-1.7.2.tgz
RUN tar -xvf sbt-1.7.2.tgz

RUN mkdir -p /app/.sbt /app/.ivy2
COPY repositories /app/.sbt/repositories
COPY entrypoint.sh /app/entrypoint.sh

ENV LANGUAGE=en_GB:en
ENV GDM_LANG=en_GB.utf8
ENV LANG=en_GB.UTF-8
ENV SBT_CREDENTIALS="/app/.ivy2/.credentials"
ENV SBT_OPTS="-Duser.home=/app -Dsbt.override.build.repos=true -Dsbt.ivy.home=/app/.ivy2"

ENTRYPOINT ["/app/entrypoint.sh"]
