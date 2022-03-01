pipeline {
    agent any

    tools {
        // Install the Maven 
        maven "maven3.8"
    }

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                //git 'https://gitlab.com/ernest.awangya/java-project.git'

                // Run Maven 
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }    
        stage('Build docker image') {
            steps {
                script {
                    def DOCKER_IMAGE = 'esso4real/pipeline:v5'
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-id', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
    
                    sh "docker build -t ${DOCKER_IMAGE} ." 
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        stage('Provisioning server') {
            environment {
                AWS_ACCESS_KEY_ID = "AKIAQN3LPLSTCCK6Y5M5"
                AWS_SECRET_KEY_ID = "MLpyM0YDS8LRIkir9Ug49VwKQJxj3jV59A81+mY3"
            }
            steps{
                script{
                    dir('terraform') {
                    sh "terraform init"
                    sh "terraform destroy --auto-approve"
                    
                    EC2_LINUX_IP = sh(
                        script: "terraform output ec2_public_ip",
                        returnStdout: true
                    ).trim()
    
                }
            }
        }
    }   
        stage ('Deploy') {
        steps {
            script {
            sleep(time:90, unit: "SECONDS") 
           
            //def REMOTE_USER = 'ec2-user' 
            //def REMOTE_HOST = '54.204.49.238'
            def ec2instance = "ec2-user@${EC2_LINUX_IP}"
            sshagent(['ec2-server-key']) {
                sh "scp -o StrictHostKeyChecking=no deploy.sh ${ec2instance}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${ec2instance} 'chmod +x deploy.sh'"
                sh "ssh -o StrictHostKeyChecking=no ${ec2instance} ./deploy.sh"
                         }
                    }   

            //sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST}"
            //sh "scp -o StrictHostKeyChecking=nodeploy.sh ${REMOTE_USER}@${REMOTE_HOST}:~/"
            //sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} 'chmod +x deploy.sh'"
            //sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} ./deploy.sh"
             
            }
        }             
    }
}
