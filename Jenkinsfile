pipeline {
    agent {
        label 'maven' // Simplified agent syntax
    }
    environment {
        PATH = "/opt/apache-maven-3.9.8/bin:$PATH"
    }
    stages {
        stage("Build") {
            steps {
                echo "---------------------unit build started--------------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "---------------------unit test completed--------------"
            }
        }
        stage("test"){
            steps{
                echo "---------------------unit test started--------------"
                sh 'mvn surefire-report:report'
                echo "---------------------unit test completed--------------"
            }
        }
        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
            }
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
