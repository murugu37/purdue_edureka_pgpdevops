pipeline {
    agent any

    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                        credentialsId: 'git-credsID' // Ensure this matches your stored Git credentials ID
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
                    // Echo statement for logging
                    sh 'echo "Build Docker Image"'

                    // Build the Docker image with the specified tag
                    sh "docker build -t murugu37/pgpdevopsproject:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Echo statement for logging
                    sh 'echo "Push to Repo"'

                    // Push the Docker image to the Docker Hub repository
                    sh "docker push murugu37/pgpdevopsproject:${IMAGE_TAG}"
                }
            }
        }

        /* Uncomment and configure if needed for updating deployment files
        stage('Update Deployment File') {
            environment {
                GIT_REPO_NAME = "pgp_devops_project"
                GIT_USER_NAME = "iam-muruga"
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        git config user.email "murugu37@gmail.com"
                        git config user.name "Murugaboopathy"
                        sed -i "s/replaceImageTag/${IMAGE_TAG}/g" java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
                        git add java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
                        git commit -m "Update deployment image to version ${IMAGE_TAG}"
                        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                    '''
                }
            }
        }
        */
    }

    post {
        always {
            // Cleanup workspace after build
            cleanWs()
        }
    }
}