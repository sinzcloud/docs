pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        APP_NAME = "weather-app"
        IMAGE_NAME = "weather-app:${BUILD_NUMBER}"
        CONTAINER_NAME = "weather-app"
        PORT = "9090"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "拉取代码..."
                git branch: 'main', url: 'https://github.com/sinzcloud/weather-springboot3.git'
            }
        }

        stage('Build') {
            steps {
                echo "Maven 打包..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                echo "构建镜像..."
                sh """
                docker build -t ${IMAGE_NAME} .
                """
            }
        }

        stage('Deploy') {
            steps {
                echo "部署容器..."
                sh """
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                docker run -d --name ${CONTAINER_NAME} -p ${PORT}:8080 ${IMAGE_NAME}
                """
            }
        }
    }

    post {
        success {
            echo "部署成功：http://服务器IP:${PORT}"
        }
        failure {
            echo "构建或部署失败，请查看日志"
        }
    }
}