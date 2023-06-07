FROM jenkins/jenkins:2.375.4-jdk11

LABEL name="jenkins master" \
      vender="opsbox.dev"

USER root

ENV TZ=Asia/Shanghai
RUN apt update && \
    apt install -y --no-install-recommends neovim net-tools \
        iputils-ping telnet zip unzip wget tzdata curl ca-certificates fontconfig locales \
        xz-utils git subversion rsync bzip2 sudo supervisor cron && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

USER jenkins

ENV JENKINS_SLAVE_AGENT_PORT 50000
COPY ./plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN cat /usr/share/jenkins/ref/plugins.txt | xargs jenkins-plugin-cli --verbose --plugins 

COPY casc-init.yaml /usr/share/jenkins/ref/casc-init.yaml
