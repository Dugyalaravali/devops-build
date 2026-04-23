pipeline {
    agent any

    environment {
        DOCKERHUB = "dugyalaravali28"
        IMAGE = "my-react-app"
        // Replace with your actual deployment server private IP or Public DNS
        DEPLOY_SERVER = "13.214.212.171" 
    }

    stages {
        // Redundant checkout removed as Declarative Pipeline does this automatically
        
        stage('Build Image') {
            steps {
                sh 'docker build -t $DOCKERHUB/$IMAGE:dev .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $DOCKERHUB/$IMAGE:dev'
            }
        }

        stage('Deploy to Prod') {
            steps {
                sshagent(['deploy-server-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${DEPLOY_SERVER} << 'EOF'
                            # Pull the new image
                            docker pull ${DOCKERHUB}/${IMAGE}:dev

                            # Stop and remove old container if it exists
                            docker rm -f myapp || true

                            # Run the new container
                            docker run -d --name myapp -p 80:80 ${DOCKERHUB}/${IMAGE}:dev
EOF
                    """
                }
            }
        }
    }
}
