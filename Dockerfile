FROM node:18-alpine

ENV SCALA_VERSION=2.13.12 \
    SCALA_HOME=/usr/share/scala \
    SBT_HOME=/usr/local/sbt

# NOTE: bash is used by scala/scalac scripts, and it cannot be easily replaced with ash.
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    apk add --no-cache bash curl jq xz && \
    cd "/tmp" && \
    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    apk del .build-dependencies && \
    rm -rf "/tmp/"* \

RUN mkdir /root

COPY ./entrypoint.sh /root/entrypoint.sh

RUN chmod +x /root/entrypoint.sh

RUN apk update && apk add ca-certificates wget tar openjdk17-jre-headless && \
    mkdir -p "${SBT_HOME}" && \
    wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v1.7.2/sbt-1.7.2.tgz" | tar xz -C "${SBT_HOME}" --strip-components=1

# Add SBT to PATH
ENV PATH="${SBT_HOME}/bin:${PATH}"

# Verify SBT installation
RUN java -Dsbt.rootdir=true -jar "${SBT_HOME}/bin/sbt-launch.jar" sbtVersion

ENTRYPOINT ["/root/entrypoint.sh"]
