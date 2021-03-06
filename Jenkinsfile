pipeline {

  environment {
    PROJECT = "southern-shard-265012"
    APP_NAME = "cicdapp"
    FE_SVC_NAME = "${APP_NAME}"
    CLUSTER = "alextest"
    CLUSTER_ZONE = "europe-west2-a"
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:v.${env.BUILD_NUMBER}"
    JENKINS_CRED = "${PROJECT}"
  }

  agent {
    kubernetes {
      label 'sample-app'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: cd-jenkins
  containers:
  - name: python
    image: python:3.6
    command:
    - cat
    tty: true
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    command:
    - cat
    tty: true
"""
}
  }
  stages {
    stage('Test') {
      steps {
        container('python') {
          sh """
            pip install flask
            ls -lah
            ln -s `pwd` /src
            cd src
            ls -lah
            python test.py
          """
        }
      }
    }
    stage('Build and push image with Container Builder') {
      steps {
        container('gcloud') {
          sh "PYTHONUNBUFFERED=1 gcloud builds submit -t ${IMAGE_TAG} ."
        }
      }
    
   }
       stage('Deploy Dev') {
      //when { branch 'dev' }
      steps {
        container('kubectl') {
          // Changing image to the one we just built
          sh("sed -i.bak 's#gcr.io/southern-shard-265012/cicdapp:v.11#${IMAGE_TAG}#' ./k8s/dev-deployment.yaml")
          step([$class: 'KubernetesEngineBuilder', namespace:'dev', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/dev-service.yaml', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
          step([$class: 'KubernetesEngineBuilder', namespace:'dev', projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/dev-deployment.yaml', credentialsId: env.JENKINS_CRED, verifyDeployments: true])
          sh("echo http://`kubectl --namespace=dev get service/${FE_SVC_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'` > ${FE_SVC_NAME}")
        }
      }
    }
  }
}
