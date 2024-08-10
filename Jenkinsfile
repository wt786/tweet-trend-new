pipeline {
    agent {
        label 'maven' // Use a specific label for your agent
    }
    environment {
        PATH = "/opt/apache-maven-3.9.8/bin:$PATH"
        registry = 'https://vodaf.jfrog.io' // Define the registry URL here
    }
    stages {
        stage("Build") {
            steps {
                script {
                    retry(3) {
                        timeout(time: 30, unit: 'MINUTES') {
                            echo "---------------------unit build started--------------"
                            sh 'mvn clean deploy -Dmaven.test.skip=true'
                            echo "---------------------unit test completed--------------"
                        }
                    }
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    retry(3) {
                        timeout(time: 15, unit: 'MINUTES') {
                            echo "---------------------unit test started--------------"
                            sh 'mvn surefire-report:report'
                            echo "---------------------unit test completed--------------"
                        }
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
            }
            steps {
                script {
                    retry(3) {
                        timeout(time: 45, unit: 'MINUTES') {
                            withSonarQubeEnv('sonarqube-server') {
                                sh "${scannerHome}/bin/sonar-scanner -X -Dsonar.exclusions=target/site/surefire-report.html"
                            }
                        }
                    }
                }
            }
        }
        stage("Jar Publish") {
            steps {
                script {
                    retry(3) {
                        echo '<--------------- Jar Publish Started --------------->'
                        def server = Artifactory.newServer(url: "${registry}/artifactory", credentialsId: "Jfrog-cre")
                        def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                        def uploadSpec = """{
                            "files": [
                                {
                                    "pattern": "jarstaging/(*)",
                                    "target": "libs-release-local/{1}",
                                    "flat": "false",
                                    "props" : "${properties}",
                                    "exclusions": [ "*.sha1", "*.md5"]
                                }
                            ]
                        }"""
                        def buildInfo = server.upload(uploadSpec)
                        buildInfo.env.collect()
                        server.publishBuildInfo(buildInfo)
                        echo '<--------------- Jar Publish Ended --------------->'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up workspace...'
            deleteDir()
        }
        failure {
            echo 'Build failed.'
        }
    }
}
