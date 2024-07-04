FROM node:20-alpine


ENV SCALA_VERSION=2.13.12 \
    SCALA_HOME=/usr/share/scala

RUN apk add --update curl bash && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && \
    source ~/.bashrc && \
    nvm install 18 && \
    nvm use 18 \

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
    rm -rf "/tmp/"* \

RUN export PATH="/usr/local/sbt/bin:$PATH" &&  apk update && apk add ca-certificates wget tar openjdk17-jre-headless && mkdir -p "/usr/local/sbt" && wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v1.7.2/sbt-1.7.2.tgz" | tar xz -C /usr/local --strip-components=1 && sbt sbtVersion

ENTRYPOINT ["/root/entrypoint.sh"]
