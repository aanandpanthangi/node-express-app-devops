pipeline {
    agent any

    environment {
        IMAGE_NAME = "anand/nodejs-app"
        DOCKER_PORT = "3002"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/<your-username>/<your-repo>.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm install'
                sh 'npm test || echo "No tests yet"'
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker stop nodejs-app || true"
                    sh "docker rm nodejs-app || true"
                    sh "docker run -d -p ${DOCKER_PORT}:${DOCKER_PORT} --name nodejs-app ${IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo "Build and Docker container deployed successfully!"
        }
        failure {
            echo "Build failed. Check Jenkins logs."
        }
    }
}
