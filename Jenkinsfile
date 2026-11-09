pipeline {
    agent any
    triggers {
        cron('H 9 * * 1-5')
        pollSCM('H/5 * * * *')
    }
    parameters {

        choice(
                name:'ENV_NAME',
                choices: ['DEV','PROD','TEST'],
                description: 'CHOOSE UR ENVIRONMENT'
                )
        string (
            name: "APP_VERSION",
            defaultValue: '1.0',
            description: "WHICH VERSION DO U PREFER")

        booleanParam(
                name: 'RUN_TEST',
                defaultValue: true,
                description: 'DO U WANT TO RUN TEST'
                )
    }
     environment{
            APP_NAME= 'STUDENT_MANAGEMENT'
    }
     options {
            timestamps()
            timeout(time:10, unit:'MINUTES')
            disableConcurrentBuilds()
            buildDiscarder(logRotator(
                numToKeepStr:'5',
                artifactNumToKeepStr:'2'
                ))
     }
     tools{
         jdk 'JDK21'
     }
    stages{
        stage('RUN_TESTS') {
            when{
                expression{
                    params.RUN_TEST== true
                }
            }
            steps{
                echo "RUN_TEST APPROVED"
                echo "RUNED APPLICATION"
                sh 'python3 test_app.py'

            }
        }
        stage("RETRY MECHANISM"){
            steps{
                retry(3){
                    echo "RETRY MECHANISM SUCCESSFULL"
                }
            }
        }
        stage("BUILD INFORMATION") {
            steps {
                echo "BUILD NUMBER:${env.BUILD_NUMBER}"
                echo "JOB NAME:${env.JOB_NAME}"
                echo "WORKSPACE:${env.WORKSPACE}"
            }
        }
        stage("PYTHON VERSION") {
            steps {
                sh 'python3 --version'
            }
        }
        stage("GIT VERSION") {
            steps {
                sh 'git --version'
            }
        }
        stage("DOCKER VERSION") {
            steps {
                sh 'docker --version'
            }
        }
        stage("DOCKER IMAGE BUILD"){
            steps{
                sh "docker build -t students:${BUILD_NUMBER} ."
            }
        }
        stage('DOCKER IMAGES PUSH') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub-credentials',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
        )]) {
            sh '''
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                docker tag students:${BUILD_NUMBER} ${DOCKER_USER}/students:${BUILD_NUMBER}

                docker push ${DOCKER_USER}/students:${BUILD_NUMBER}

                docker logout
            '''
        }
    }
}
        stage("PARALLEL STAGING"){
            parallel {
                stage("JAVA --VERSION "){
                    steps{
                        sh 'java --version'
                    }
                }
                stage("JAVAC VERSION"){
                    steps{
                        sh 'javac --version'
                    }
                }
            }
        }
        stage("APP NAME"){
            steps{
                echo "APP_NAME:${env.APP_NAME}"
                echo "APP_VERSION:${params.APP_VERSION}"
            }
        }
    }
    post{
        success {
            echo "PIPELINE SUCCESSFULL"
        }
        failure {
            echo "PIPELINE FAILED"
        }
        always {
            echo "PIPELINE FINISHED"
        }
    }
}
