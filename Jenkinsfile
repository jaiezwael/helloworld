pipeline {
  agent any

  parameters {
    string(name: 'DOCKER_REGISTRY', defaultValue: 'docker.io', description: 'Docker registry to push the image to')
  }

  environment {
    JELASTIC_DOMAIN = 'app.p4d.click'
    APP_NAME = 'helloworld'
    DOCKER_IMAGE_NAME = 'waelj17/helloworld:2.0'
    DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'docker build -t "waelj17/hellowrold:2.0" .'
        sh 'docker push "waelj17/helloworld:2.0"'
      }
    }

    stage('Unit Test') {
      steps {
        sh 'docker run --rm "waelj17/helloworld:2.0" mvn test'
      }
    }

    stage('SonarQube Scan') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh 'docker run --rm -e SONAR_HOST_URL="http://docker14529-mysonarqube.my.p4d.click/" -e SONAR_TOKEN="squ_630d5084e2dd1938cb531f941a6e444bf4a31897" "waelj17/helloworld:2.0" mvn -B -e verify sonar:sonar'
        }
      }
    }


    stage('Deploy to Jelastic') {
      steps {
        withCredentials([string(credentialsId: 'Jelastic', variable: 'JELASTIC_CREDENTIALS')]) {
          sh "curl -k -X POST -u \"${JELASTIC_CREDENTIALS}\" -H \"Content-Type: application/json\" -d '{\"image\":\"waelj17/helloworld:2.0\",\"name\":\"helloworld\",\"envName\":\"myenv\",\"nodeGroup\":\"myenv\",\"nodeType\":\"DOCKERIZED\",\"count\":1,\"ports\":[{\"protocol\":\"TCP\",\"publicPort\":80,\"privatePort\":8080}],\"restartPolicy\":\"ALWAYS\",\"uploadMetaInfo\":true}' https://app.p4d.click/1.0/environment/control/rest/deploycontainersbydockerimage"
        }
      }
    }

    post {
      success {
        mail to: 'wael.jaiez@sesame.com.tn',
             subject: "${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - SUCCESS",
             body: "The build was successful!"
      }

      failure {
        mail to: 'wael.jaiez@sesame.com.tn',
             subject: "${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - FAILED",
             body: "The build failed. Please check the Jenkins logs for more details."
      }
    }
  }
}
