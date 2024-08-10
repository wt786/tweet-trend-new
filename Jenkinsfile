pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    echo '---------------------unit build started--------------'
                    sh 'mvn clean deploy -Dmaven.test.skip=true'
                    echo '---------------------unit build completed--------------'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo '---------------------unit test started--------------'
                    sh 'mvn surefire-report:report'
                    echo '---------------------unit test completed--------------'
                }
            }
        }
        