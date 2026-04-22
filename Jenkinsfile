pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'dugyalaravali28'
        DEV_REPO = "${dugyalaravali28}/dev-repo"
        PROD_REPO = "${dugyalaravali28}/prod-repo"
    }

    stages {
        stage('Build Image') {
            steps {
                script {
                    // Build with a temporary tag
                    sh "chmod +x build.sh"
                    sh "./build.sh web-app latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials-id') {
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker tag web-app latest ${DEV_REPO}:latest"
                            sh "docker push ${DEV_REPO}:latest"
                        } 
                        else if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
                            sh "docker tag web-app latest ${PROD_REPO}:latest"
                            sh "docker push ${PROD_REPO}:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy to AWS') {
            // Only deploy if on master/main branch
            when {
                branch 'main'
            }
            steps {
                sshagent(['aws-ec2-ssh-key-id']) {
                    sh "chmod +x deploy.sh"
                    // Connect to EC2 and run the deploy script
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@your-ec2-ip 'bash -s' < deploy.sh ${PROD_REPO}:latest"
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
