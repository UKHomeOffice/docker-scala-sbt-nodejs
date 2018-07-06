FROM quay.io/ukhomeofficedigital/scala-sbt:latest

# Install Scala.js dependencies
RUN \
  curl -sL https://raw.githubusercontent.com/nodesource/distributions/master/rpm/setup_6.x | bash - && \
  yum install -y nodejs && \
  npm install jsdom@v9 source-map-support

# Install yarn

RUN \
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
  yum install -y yarn

ENTRYPOINT ["/root/entrypoint.sh"]
