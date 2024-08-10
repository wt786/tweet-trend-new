pipeline {
    agent {
        label 'maven'
    }
    environment {
        PATH = "/opt/apache-maven-3.9.8/bin:$PATH"
    }
    stages {
        stage("Build") {
            steps {
                echo "--------------------- Build Started ---------------------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "--------------------- Build Completed ---------------------"
            }
        }
        stage("Test") {
            steps {
                echo "--------------------- Unit Test Started ---------------------"
                sh 'mvn surefire-report:report'
                echo "--------------------- Unit Test Completed ---------------------"
            }
        }
        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
            }
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner -X -Dsonar.javascript.linter.timeout=120000"
                }
            }
        }
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url: registry + "/artifactory", credentialsId: "Jfrog-cre"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "libs-release-local/{1}",
                                "flat": "false",
                                "props" : "${properties}",
                                "exclusions": [ "*.sha1", "*.md5" ]
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
    post {
        always {
            echo "Cleaning up workspace..."
            deleteDir() // Clean up the workspace after the build
        }
        success {
            echo "Build completed successfully."
        }
        failure {
            echo "Build failed."
        }
    }
}
