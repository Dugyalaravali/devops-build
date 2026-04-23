pipeline {
    agent any

    environment {
        DOCKERHUB = "dugyalaravali28"
        DEV_IMAGE = "my-react-app-dev"
        PROD_IMAGE = "my-react-app-prod" // Ensure this is created as PRIVATE in Docker Hub
        DEPLOY_SERVER = "13.214.212.171"
    }

    stages {
        stage('Build & Push Dev') {
            steps {
                // Build the image using the Dev name
                sh 'docker build -t $DOCKERHUB/$DEV_IMAGE:dev .'
                
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $DOCKERHUB/$DEV_IMAGE:dev'
                }
            }
        }

        stage('Promote to Prod Repo') {
            steps {
                // Retag the dev image to the prod repository name
                sh """
                    docker tag $DOCKERHUB/$DEV_IMAGE:dev $DOCKERHUB/$PROD_IMAGE:latest
                    docker push $DOCKERHUB/$PROD_IMAGE:latest
                """
            }
        }

        stage('Deploy to Prod Server') {
            steps {
                sshagent(['deploy-server-key']) {
                    // We need credentials here because the Prod repo is PRIVATE
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-creds', 
                        usernameVariable: 'USER', 
                        passwordVariable: 'PASS'
                    )]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${DEPLOY_SERVER} << EOF
                                # Log in on the remote server to access the PRIVATE repo
                                echo ${PASS} | docker login -u ${USER} --password-stdin
                                
                                # Pull and run the Prod image
                                docker pull ${DOCKERHUB}/${PROD_IMAGE}:latest
                                docker rm -f my-react-app-prod || true
                                docker run -d --name my-react-app-prod -p 80:80 ${DOCKERHUB}/${PROD_IMAGE}:latest
EOF
                        """
                    }
                }
            }
        }
    }
}
