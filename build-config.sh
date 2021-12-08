#!/bin/bash
cat <<EOF | oc create -f - 
kind: BuildConfig
apiVersion: build.openshift.io/v1
metadata:
  name: $1
spec:
  nodeSelector: {}
  strategy:
    type: Docker
  source:
    type: Git
    git:
      uri: 'https://github.com/martinmlkvy/ditec-cicd.git'
      ref: main
  output:
    to:
      kind: DockerImage
      name: 'quay.io/cerveny/ditec-cicd:jenkins-verzia-$1'
    pushSecret:
      name: quay-credentials
EOF