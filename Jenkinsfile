pipeline {
    agent any

    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'docker-cred'
        GIT_CREDENTIALS_ID = 'git-credsID'
        TARGET_INSTANCE_IP = '54.237.68.20'
        TARGET_USER = 'ubuntu'
        KUBECONFIG_PATH = '/etc/kubernetes/admin.conf'
        SSH_CREDENTIALS_ID = 'ssh-credentials-id'
        DEPLOY_NAME = 'pgpapp'
        IMAGE_NAME = "murugu37/pgpdevopsproject:${IMAGE_TAG}"
        SERVICE_NAME = 'svc1'
        NODE_PORT = 8037
        TARGET_PORT = 8037
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/murugu37/purdue_edureka_pgpdevops.git',
                        credentialsId: "${env.GIT_CREDENTIALS_ID}"
                    ]]
                ])
            }
        }

        stage('Build and Test') {
            steps {
                sh 'ls -ltr'
                sh 'mvn compile'
                sh 'mvn test'
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker version || { echo "Docker is not running"; exit 1; }'
                    echo 'Building Docker Image'
                    sh "docker build -t murugu37/pgpdevopsproject:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Docker Image to Repo'
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    }
                    sh "docker push murugu37/pgpdevopsproject:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sshagent([env.SSH_CREDENTIALS_ID]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.TARGET_USER}@${env.TARGET_INSTANCE_IP} '
                                sudo kubectl --kubeconfig=${env.KUBECONFIG_PATH} delete deploy ${env.DEPLOY_NAME} || true
                                sudo kubectl --kubeconfig=${env.KUBECONFIG_PATH} create deploy ${env.DEPLOY_NAME} --image=${env.IMAGE_NAME} --replicas=2 &&
                                sudo kubectl --kubeconfig=${env.KUBECONFIG_PATH} expose deploy ${env.DEPLOY_NAME} --name=${env.SERVICE_NAME} --type=NodePort --protocol=TCP --port=${env.NODE_PORT} --target-port=${env.TARGET_PORT} || true
                            '
                        """
                    }
                }
            }
        }

    }

    post {
        always {
            cleanWs()
        }
    }
}
