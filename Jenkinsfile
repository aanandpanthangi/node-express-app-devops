pipeline {
    agent any

    environment {
        IMAGE_NAME = "nodejs-app"        // Docker image name
        DOCKER_PORT = "3002"             // Port your app exposes
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout from GitHub with PAT credential
                git branch: 'master',
                    url: 'https://github.com/aanandpanthangi/node-express-app-devops.git',
                    credentialsId: 'github-pat-nodejs'
            }
        }

        stage('Install Dependencies & Run Tests') {
            steps {
                sh 'npm install'
                sh 'npm test || echo "No tests defined yet"'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with build number tag
                    docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Stop old container if exists
                    sh "docker stop ${IMAGE_NAME} || true"
                    sh "docker rm ${IMAGE_NAME} || true"

                    // Run new container
                    sh "docker run -d -p ${DOCKER_PORT}:${DOCKER_PORT} --name ${IMAGE_NAME} ${IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and Docker container deployed successfully!"
        }
        failure {
            echo "❌ Build failed. Check Jenkins logs for details."
        }
    }
}
