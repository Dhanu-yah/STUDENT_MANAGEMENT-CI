
pipeline {
    agent any

    triggers {
        cron('H 9 * * 1-5')
        pollSCM('H/5 * * * *')
    }

    parameters {
        choice(
            name: 'ENV_NAME',
            choices: ['DEV', 'PROD', 'TEST'],
            description: 'CHOOSE YOUR ENVIRONMENT'
        )

        string(
            name: 'APP_VERSION',
            defaultValue: '1.0',
            description: 'APPLICATION VERSION'
        )

        booleanParam(
            name: 'RUN_TEST',
            defaultValue: true,
            description: 'DO YOU WANT TO RUN TESTS?'
        )

        booleanParam(
            name: 'TF_PLAN',
            defaultValue: false,
            description: 'APPROVE CREATION OF AWS INFRASTRUCTURE'
        )
    }

    environment {
        APP_NAME = 'STUDENT_MANAGEMENT'
    }

    options {
        timestamps()
        disableConcurrentBuilds()

        buildDiscarder(logRotator(
            numToKeepStr: '5',
            artifactNumToKeepStr: '2'
        ))
    }

    tools {
        jdk 'JDK21'
    }

    stages {

        stage('RUN TESTS') {
            when {
                expression {
                    params.RUN_TEST == true
                }
            }
            steps {
                echo 'RUN_TEST APPROVED'
                echo 'RUNNING APPLICATION TESTS'
                sh 'python3 test_app.py'
            }
        }

        stage('RETRY MECHANISM') {
            steps {
                retry(3) {
                    echo 'RETRY MECHANISM EXECUTED'
                }
            }
        }

        stage('BUILD INFORMATION') {
            steps {
                echo "BUILD NUMBER: ${env.BUILD_NUMBER}"
                echo "JOB NAME: ${env.JOB_NAME}"
                echo "WORKSPACE: ${env.WORKSPACE}"
            }
        }

        stage('TERRAFORM INIT') {
            steps {
                sh 'terraform init -input=false'
            }
        }

        stage('TERRAFORM VALIDATE') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('TERRAFORM PLAN') {
            steps {
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('TERRAFORM APPLY') {
            when {
                expression {
                    params.TF_PLAN == true
                }
            }
            steps {
                input(
                    message: 'APPROVE CREATING AWS INFRASTRUCTURE?',
                    ok: 'Approve'
                )

                sh 'terraform apply -input=false tfplan'
            }
        }

        stage('DOCKER VERSION') {
            steps {
                sh 'docker --version'
            }
        }

        stage('DOCKER IMAGE BUILD') {
            steps {
                sh 'docker build -t students:${APP_VERSION}-${BUILD_NUMBER} .'
            }
        }

        stage('DOCKER IMAGE PUSH') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" --password-stdin

                        docker tag students:${APP_VERSION}-${BUILD_NUMBER} \
                        ${DOCKER_USER}/students:${APP_VERSION}-${BUILD_NUMBER}

                        docker push \
                        ${DOCKER_USER}/students:${APP_VERSION}-${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }

        stage('PARALLEL STAGING') {
            parallel {
                stage('JAVA VERSION') {
                    steps {
                        sh 'java --version'
                    }
                }

                stage('JAVAC VERSION') {
                    steps {
                        sh 'javac --version'
                    }
                }
            }
        }

        stage('APP NAME') {
            steps {
                echo "APP NAME: ${env.APP_NAME}"
                echo "APP VERSION: ${params.APP_VERSION}"
                echo "ENVIRONMENT: ${params.ENV_NAME}"
            }
        }
    }

    post {
        success {
            echo 'PIPELINE SUCCESSFUL'
        }

        failure {
            echo 'PIPELINE FAILED'
        }

        always {
            echo 'PIPELINE FINISHED'
        }
    }
}

