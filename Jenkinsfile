pipeline {
    agent {
        docker {
            image 'maven:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_REPO = 'your-docker-repo/your-image-name'
        K8S_NAMESPACE = 'your-kubernetes-namespace'
        K8S_DEPLOYMENT = 'your-deployment-name'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'ed5260b743c24bec8eaaf2eefa0cf09c', url: 'https://github.com/murugu37/purdue_edureka_pgpdevops.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REPO}:${BUILD_NUMBER}")
                }
            }
        }

        //stage('Push to Docker Repo') {
            //steps {
              //  script {
                   // docker.withRegistry('https://your-docker-repo', 'your-docker-credentials-id') {
                        //docker.image("${DOCKER_REPO}:${BUILD_NUMBER}").push()
                   // }
               // }
          //  }
       // }

       // stage('Deploy to Kubernetes') {
           // steps {
               // script {
                    //sh 'kubectl set image deployment/${K8S_DEPLOYMENT} ${K8S_DEPLOYMENT}=${DOCKER_REPO}:${BUILD_NUMBER} -n ${K8S_NAMESPACE}'
                //}
            //}
        //}
    }
}
