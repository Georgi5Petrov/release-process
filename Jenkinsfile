pipeline {
    agent any

    stages { 
        stage('Installl') {
            steps {
                script {
                    try {
                        withMaven(jdk: 'JAVA8-3', maven: 'Maven3') 
                        {
                        sh 'whoami'
                        //sh 'mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false'
                        //sh '/var/jenkins_home/workspace/pipeline-job/my-app'
                        sh 'pwd'
                        sh 'ls -la'
                        dir('/var/lib/jenkins/workspace/pipeline/mvn-project') {
                          sh "pwd"
                          sh 'ls -la'
                          sh 'mvn clean install'
                        }
                        }
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
                        withMaven(jdk: 'JAVA8-3', maven: 'Maven3') {
                            dir('/var/lib/jenkins/workspace/pipeline/mvn-project') {
                        sh 'mvn compile'
                        }
                        }
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
                        withMaven(jdk: 'JAVA8-3', maven: 'Maven3') {
                            dir('/var/lib/jenkins/workspace/pipeline/mvn-project') {
                        sh 'mvn test'
                            }
                        }
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
                        withSonarQubeEnv{
                            withMaven(installationName: 'SonarQube', jdk: 'JAVA8-3', maven: 'Maven3') {
                                dir('/var/lib/jenkins/workspace/pipeline/mvn-project') {
                            sh 'touch report-task.txt'
                            sh 'java -version'
                            sh 'mvn -version'
                            sh 'mvn clean package sonar:sonar'
                            }
                            }
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
                            sh 'pwd | ls -ls'
                            sh 'docker build -t my-app:latest .'
                            sh 'docker image list'
                            //sh 'docker login my-artifactory-docker-registry.com -u $ARTIFACTORY_DOCKER_USER -p $ARTIFACTORY_DOCKER_PASSWORD'
                            //sh 'docker tag my-app:latest my-artifactory-docker-registry.com/my-app:latest'
                            //sh 'docker push my-artifactory-docker-registry.com/my-app:latest'
                        }
                    } catch (Exception e) {
                        echo 'Dockerization failed with exception: ' + e.getMessage()
                        currentBuild.result = 'FAILURE'
                        error("STOP!!!") 
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
