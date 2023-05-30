FROM jenkins/jenkins:2.375.4-jdk11

LABEL name="jenkins master" \
      vender="opsbox.dev"

ENV JENKINS_SLAVE_AGENT_PORT 50000
COPY ./plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN cat /usr/share/jenkins/ref/plugins.txt | xargs jenkins-plugin-cli --verbose --plugins 

COPY casc-init.yaml /usr/share/jenkins/ref/casc-init.yaml