FROM quay.io/ukhomeofficedigital/scala-sbt:v0.4.0

# Install NodeJs
RUN \
  curl -sL https://raw.githubusercontent.com/nodesource/distributions/master/rpm/setup_12.x | bash - && \
  yum install -y nodejs

# Install yarn
RUN \
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
  yum install -y yarn

ENTRYPOINT ["/root/entrypoint.sh"]
