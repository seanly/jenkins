# jenkins


##
```bash
tar -cvzf /tmp/jenkins_home.tar.gz --exclude=jobs --exclude=plugins --exclude=workspace --exclude=workflow-libs --exclude=jobs.bak --exclude=monitoring --exclude=fingerprints --exclude=jenkins_home/war --exclude=logs --exclude=jenkins-slave-* --exclude=.java --exclude=.cache --exclude=.fonts --exclude=groovy  /jenkins_home
```