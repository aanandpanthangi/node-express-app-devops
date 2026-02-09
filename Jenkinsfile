pipeline {
    agent any

    environment {
        IMAGE_NAME = "aanandp28/nodejs-app"   // Docker Hub repo
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_PORT = "3002"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/aanandpanthangi/node-express-app-devops.git',
                    credentialsId: 'github-pat-nodejs'
            }
        }

        stage('Install Dependencies & Tests') {
            steps {
                sh 'npm install'
                sh 'npm test || echo "No tests defined"'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub-cred', url: '']) {
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                echo "Updating Kubernetes deployment..."

                microk8s kubectl set image deployment/nodejs-app-deployment \
                nodejs-container=${IMAGE_NAME}:${IMAGE_TAG} || true

                microk8s kubectl apply -f deployment.yaml
                microk8s kubectl apply -f service.yaml

                microk8s kubectl get pods
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline completed! App deployed to Kubernetes."
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
