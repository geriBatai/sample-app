def version
def endpoint

pipeline {
    agent any

    // triggers {
    //     pollSCM('H/1 * * * *')
    // }

    stages {

        stage("initialise") {
            steps {
                script {
                    version = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    endpoint = "http://localhost:9999"
                    service  = "sample-app"
                }
            }
        }

        stage("build") {
            steps {
                script {
                    sh "docker build -t geribatai/${service}:${version} ."
                    sh "docker push geribatai/${service}:${version}"
                }
            }
        }


        stage("deploy") {
            steps {
                script {
                    sh "./deploy.sh -e ${endpoint} -n ${service} -v ${version}"
                }
            }
        }

        stage("test") {
            steps {
                script {
                    sh "curl -s http://maindomain.example/env"
                }
            }
        }

    }
}
