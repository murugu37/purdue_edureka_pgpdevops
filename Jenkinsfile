pipeline {
    agent any

    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'docker-cred' // Ensure this matches your stored Docker credentials ID
        GIT_CREDENTIALS_ID = 'git-credsID' // Ensure this matches your stored Git credentials ID
        TARGET_INSTANCE_IP = '54.196.193.42' // Replace with the actual IP address of the target EC2 instance
        TARGET_USER = 'ubuntu' // Replace with the actual SSH username for the target instance
        KUBECONFIG_PATH = '/etc/kubernetes/admin.conf' // Ensure this path is valid on the target instance
        SSH_CREDENTIALS_ID = 'ssh-credentials-id' // Ensure this matches your stored SSH credentials ID
        DEPLOY_NAME = 'pgpapp'
        IMAGE_NAME = "murugu37/pgpdevopsproject:${IMAGE_TAG}"
        SERVICE_NAME = 'svc1'
        NODE_PORT = 8080
        TARGET_PORT = 8080
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout the code from the specified Git repository using stored credentials
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
                // List files in the workspace (for debugging purposes)
                sh 'ls -ltr'

                // Compile the Maven project
                sh 'mvn compile'

                // Run the tests using Maven
                sh 'mvn test'

                // Package the project, typically creating a JAR or WAR file
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Check if Docker is running
                    sh 'docker version || { echo "Docker is not running"; exit 1; }'

                    // Echo statement for logging
                    echo 'Building Docker Image'

                    // Build the Docker image with the specified tag
                    sh "docker build -t murugu37/pgpdevopsproject:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Echo statement for logging
                    echo 'Pushing Docker Image to Repo'

                    // Login to Docker Hub (if needed, otherwise ensure the Jenkins Docker plugin handles this)
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    }

                    // Push the Docker image to the Docker Hub repository
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
                                sudo kubectl --kubeconfig=${env.KUBECONFIG_PATH} create deploy ${env.DEPLOY_NAME} --image=${env.IMAGE_NAME} --replicas=2 &&
                                sudo kubectl --kubeconfig=${env.KUBECONFIG_PATH} expose deploy ${env.DEPLOY_NAME} --name=${env.SERVICE_NAME} --type=NodePort --protocol=TCP --port=${env.NODE_PORT} --target-port=${env.TARGET_PORT}
                            '
                        """
                    }
                }
            }
        }

    }

    post {
        always {
            // Cleanup workspace after build
            cleanWs()
        }
    }
}
