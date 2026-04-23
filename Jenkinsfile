pipeline {
    agent any

    environment {
        // Docker Hub details
        DOCKERHUB = "dugyalaravali28"
        DEV_IMAGE = "my-react-app-dev"
        PROD_IMAGE = "my-react-app-prod" 
        
        // Deployment Server details
        DEPLOY_SERVER = "13.214.212.171"
    }

    stages {
        stage('Build & Push Dev') {
            steps {
                // Build the image using the Dev repository name
                sh 'docker build -t $DOCKERHUB/$DEV_IMAGE:dev .'

                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    // Login to Docker Hub
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    // Push to the public dev repository
                    sh 'docker push $DOCKERHUB/$DEV_IMAGE:dev'
                }
            }
        }

        stage('Promote to Prod Repo') {
            steps {
                // Retag the verified dev image to the prod repository name
                sh """
                    docker tag $DOCKERHUB/$DEV_IMAGE:dev $DOCKERHUB/$PROD_IMAGE:latest
                    docker push $DOCKERHUB/$PROD_IMAGE:latest
                """
            }
        }

        stage('Deploy to Prod Server') {
            steps {
                // Use SSH agent for secure key handling
                sshagent(['deploy-server-key']) {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-creds',
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${DEPLOY_SERVER} << EOF
                                # 1. Log in on the remote server to pull from the PRIVATE repo
                                echo ${PASS} | docker login -u ${USER} --password-stdin

                                # 2. Pull the latest Production image
                                docker pull ${DOCKERHUB}/${PROD_IMAGE}:latest

                                # 3. CLEANUP: Force remove any container using Port 80
                                # This prevents the "Port is already allocated" error 
                                docker rm -f \\\$(docker ps -q --filter "publish=80") || true
                                
                                # Also remove by specific names used previously
                                docker rm -f myapp my-react-app-prod || true

                                # 4. Run the new container on Port 80
                                docker run -d --name my-react-app-prod -p 80:80 ${DOCKERHUB}/${PROD_IMAGE}:latest
EOF
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Clean up the workspace after the build
            cleanWs()
        }
    }
}
