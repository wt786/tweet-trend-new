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


