pipeline {
    agent any

    stages {
        stage('Build with Maven') {
            steps {
                sh 'cd SampleWebApp && mvn clean install'
            }
        }

        stage('Test') {
            steps {
                sh 'cd SampleWebApp && mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    cd SampleWebApp && mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                      -Dsonar.projectKey=SampleWebApp \
                      -Dsonar.projectName=SampleWebApp
                    '''
                }
            }
        }

        stage('Upload Artifact to Nexus') {
            steps {
                nexusArtifactUploader artifacts: [[
                    artifactId: 'SampleWebApp',
                    classifier: '',
                    file: 'SampleWebApp/target/SampleWebApp.war',
                    type: 'war'
                ]],
                credentialsId: 'nexus',
                groupId: 'SampleWebApp',
                nexusUrl: 'ec2-44-195-40-117.compute-1.amazonaws.com:8081',
                nexusVersion: 'nexus3',
                protocol: 'http',
                repository: 'maven-snapshots',
                version: '1.0-SNAPSHOT'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [
                    tomcat9(
                        alternativeDeploymentContext: '',
                        credentialsId: 'tomcat',
                        path: '',
                        url: 'http://34.205.131.64:8080/'
                    )
                ],
                contextPath: 'myapp',
                war: 'SampleWebApp/target/SampleWebApp.war'
            }
        }
    }
}