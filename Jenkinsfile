def registry = 'https://vodaf.jfrog.io/'
pipeline {
    agent {
        label 'maven' // Use a Maven-specific agent
    }
    environment {
        PATH = "/opt/apache-maven-3.9.8/bin:$PATH"
    }
    stages {
        stage("Build") {
            steps {
                echo "---------------------unit build started--------------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "---------------------unit build completed--------------"
            }
        }
        stage("Test") {
            steps {
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
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url: "${registry}/artifactory", credentialsId: "Jfrog-cre"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "libs-release-local/{1}",
                                "flat": false,
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
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
