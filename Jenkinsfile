pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.8/bin:$PATH"
    }
    stages {
        stage("build pipes") {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}


http://18.170.66.61:8080/job/Multi-Branch/configure/multibranch-webhook-trigger/invoke?token=waq-pro

http://18.170.66.61:8080
http://18.170.66.61:8080/multibranch-webhook-trigger/invoke?token=waq-pro