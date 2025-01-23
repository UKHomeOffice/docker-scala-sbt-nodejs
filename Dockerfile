FROM node:20-bookworm

RUN export PATH="/usr/local/sbt/bin:$PATH"

RUN apt update

RUN wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
RUN dpkg -i jdk-21_linux-x64_bin.deb
#RUN apt install -y openjdk-21-jre-headless ca-certificates curl tar git protobuf-compiler
#RUN apt clean

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

ENTRYPOINT ["/root/entrypoint.sh"]
