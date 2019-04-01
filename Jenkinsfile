def version
def endpoint

pipeline {
    agent any

    triggers {
        pollSCM('H/1 * * * * *')
    }

    stages {

        stage("initialise") {
            steps {
                script {
                    version = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    endpoint = "http://localhost:8080"
                }
            }
        }

        stage("build") {
            steps {
                script {
                    sh "docker build -t geribatai/sample-app:${version} ."
                    sh "docker push geribatai/sample-app:${version}"
                }
            }
        }


        stage("deploy") {
            steps {
                script {
                    sh "./deploy.sh --endpoint ${endpoint} --version ${version}"
                }
            }
        }

        stage("test") {
            steps {
                script {
                    sh "curl http://maindomain.example/env"
                }
            }
        }

    }
}
