FROM node:20-alpine


RUN export PATH="/usr/local/sbt/bin:$PATH"
RUN apk update
RUN apk add --no-cache openjdk21-jre-headless
RUN apk add --no-cache bash ca-certificates curl tar git
RUN echo "Checking git installation..." && \
    ls -la /usr/bin/ && \
    ls -la /usr/local/bin/ && \
    ls -la /bin/ && \
    which git && \
    git --version
RUN mkdir -p "/usr/local/sbt" && curl -L "https://github.com/sbt/sbt/releases/download/v1.9.7/sbt-1.9.7.tgz" | tar -xvz -C /usr/local --strip-components=1
RUN sbt -Dsbt.rootdir=true sbtVersion



RUN addgroup -g 1001 app
RUN adduser -G app -u 1001 -h /app -D app
RUN mkdir -p /app
RUN chown -R app:app /app

WORKDIR /app

RUN mkdir -p /app/.sbt /app/.ivy2
COPY repositories /app/.sbt/repositories
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENV LANGUAGE=en_GB:en
ENV GDM_LANG=en_GB.utf8
ENV LANG=en_GB.UTF-8
ENV SBT_CREDENTIALS="/app/.ivy2/.credentials"
ENV SBT_OPTS="-Duser.home=/app -Dsbt.override.build.repos=true -Dsbt.ivy.home=/app/.ivy2"

ENTRYPOINT ["/app/entrypoint.sh"]
