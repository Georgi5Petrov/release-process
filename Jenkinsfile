pipeline {
    agent any

    stages {
        stage("Setup")
        {  
        checkout scm

        }
        stage('Installl') {
            steps {
                script {
                    try {
                        sh 'mvn clean install'
                    } catch (Exception e) {
                        echo 'Install failed with exception: ' + e.getMessage()
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    try {
                        sh 'mvn compile'
                    } catch (Exception e) {
                        echo 'Build failed with exception: ' + e.getMessage()
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    try {
                        sh 'mvn test'
                    } catch (Exception e) {
                        echo 'Tests failed with exception: ' + e.getMessage()
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Code Analysis') {
            steps {
                script {
                    try {
                        withSonarQubeEnv('My SonarQube Server') {
                            sh 'mvn sonar:sonar'
                        }
                    } catch (Exception e) {
                        echo 'SonarQube analysis failed with exception: ' + e.getMessage()
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Dockerize') {
            steps {
                script {
                    try {
                        withCredentials([usernamePassword(credentialsId: 'artifactoryDockerCredentials', usernameVariable: 'ARTIFACTORY_DOCKER_USER', passwordVariable: 'ARTIFACTORY_DOCKER_PASSWORD')]) {
                            sh 'docker build -t my-app:latest .'
                            sh 'docker login my-artifactory-docker-registry.com -u $ARTIFACTORY_DOCKER_USER -p $ARTIFACTORY_DOCKER_PASSWORD'
                            sh 'docker tag my-app:latest my-artifactory-docker-registry.com/my-app:latest'
                            sh 'docker push my-artifactory-docker-registry.com/my-app:latest'
                        }
                    } catch (Exception e) {
                        echo 'Dockerization failed with exception: ' + e.getMessage()
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Helm Deploy') {
            steps {
                script {
                    try {
                        sh 'helm upgrade --install my-app ./helm-chart --set image.repository=my-artifactory-docker-registry.com/my-app,image.tag=latest'
                    } catch (Exception e) {
                        echo 'Helm deployment failed with exception: ' + e.getMessage()
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Notify') {
            steps {
                script {
                    // Send an email
                    emailext body: 'The build was successful.',
                             subject: 'Build Success',
                             to: 'team@example.com'

                    // Send a Slack message
                    slackSend color: 'good', 
                              message: 'The build was successful.', 
                              channel: '#build-notifications'
                }
            }
        }

        stage('Promote') {
            steps {
                script {
                    // Promote the artifact
                    promote(
                        jobName: 'my-job',
                        condition: 'Successful',
                        parameterName: 'PROMOTED_JOB',
                        parameterValue: 'my-job'
                    )
                }
            }
        }
    }
}
