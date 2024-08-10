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
        stage('Jar Publish') {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer(url: 'https://vodaf.jfrog.io/artifactory', credentialsId: 'Jfrog-cre')
                    def buildInfo = Artifactory.newBuildInfo()

                    try {
                        server.upload spec: """{
                            "files": [{
                                "pattern": "target/*.jar",
                                "target": "libs-release-local/com/valaxy/demo-workshop/"
                            },
                            {
                                "pattern": "target/*.pom",
                                "target": "libs-release-local/com/valaxy/demo-workshop/"
                            }]
                        }""", buildInfo: buildInfo
                        
                        server.publishBuildInfo buildInfo
                        echo '<--------------- Jar Publish Completed --------------->'
                    } catch (Exception e) {
                        echo "Error during artifact upload: ${e.getMessage()}"
                        error "Build failed due to artifact upload error."
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                echo 'Cleaning up workspace...'
                deleteDir()
            }
        }
        failure {
            script {
                echo 'Build failed.'
            }
        }
    }
}
