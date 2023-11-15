# vim: set ft=dockerfile:

FROM alpine:3.18

LABEL name="jenkins slave" \
      vender="opsbox.dev"

ENV JENKINS_HOME /home/jenkins

# tools
COPY --from=seanly/opsbox:toolset \
        /usr/bin/yq \
        /usr/bin/docker-compose \
        /usr/bin/helm \
        /usr/bin/kustomize \
        /usr/bin/kubectl \
    /usr/bin/

# docker
COPY --from=seanly/toolset:docker /install/docker/usr/bin/* /usr/bin/
COPY --from=seanly/toolset:docker /root/.docker /root/.docker
COPY --from=seanly/toolset:dapper /usr/bin/dapper /usr/bin/dapper

ENV DOCKER_CLI_EXPERIMENTAL=enabled
ENV DOCKER_BUILDKIT=1

ARG SLAVE_VERSION=4.14
ARG SWARM_VERSION=3.39

RUN set -eux \
  && apk update \
  && apk add iptables  xz pigz curl ca-certificates bash openjdk11\
    git subversion rsync bzip2 sudo supervisor cronie net-tools procps-ng mtr iproute2\
  && addgroup -S dockremap \
  && adduser -S -G dockremap dockremap \
  && echo 'dockremap:165536:65536' >> /etc/subuid \
  && echo 'dockremap:165536:65536' >> /etc/subgid \
  && addgroup -S docker \
  && adduser -S -G docker docker \
  && mkdir -p /usr/share/jenkins \
  && chmod 755 /usr/share/jenkins \
  && curl --create-dirs -sSLo /usr/share/jenkins/swarm-client.jar \
    https://repo.jenkins-ci.org/artifactory/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}.jar \
  && chmod 644 /usr/share/jenkins/swarm-client.jar \
  && curl --create-dirs -sSLo /usr/share/jenkins/slave.jar \
    https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${SLAVE_VERSION}/remoting-${SLAVE_VERSION}.jar \
  && chmod 644 /usr/share/jenkins/slave.jar

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8     

COPY ./rootfs /

VOLUME /var/lib/docker
EXPOSE 2375 2376
ENTRYPOINT ["/entrypoint.sh"]
