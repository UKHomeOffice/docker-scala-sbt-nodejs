FROM quay.io/ukhomeofficedigital/scala-sbt:v0.5.0

# Install NodeJs
RUN yum install https://rpm.nodesource.com/pub_20.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
RUN yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1

# Install yarn
RUN npm install --global yarn

ENTRYPOINT ["/root/entrypoint.sh"]
