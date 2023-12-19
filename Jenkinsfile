pipeline {
    agent any 

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                #sh './gradlew build' // run the actual build command 
            }
        }
        stage('Test'){
            steps{
                echo 'Testing..'
                #sh './gradlew test' // run the actual test command
            }
        }
        stage('Deploy'){
            steps{
                echo 'Deploying....'
                #sh './gradlew deploy' // run the actual deployment command
            }
        }
    }
}
