pipeline {
    agent any

    environment {
        DOCKERHUB = "dugyalaravali28"
        IMAGE = "my-react-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/Dugyalaravali/devops-build.git'
            }
        }

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

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
