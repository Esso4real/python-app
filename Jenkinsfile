pipeline {
    agent any

    environment {
        IMAGE_NAME = 'esso4real/python-app:v1'
    }
    stages {  
        stage('Build docker image') {
            steps {
                script {
                    echo 'building the image from Dockerfile.. .. .. .'
                    echo "connecting to dockerhub repository, and pushing the ${IMAGE_NAME} image .. .. ." 

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-id', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
    
                    sh "docker build -t ${IMAGE_NAME} ." 
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}"
                    }
                }
            }
        }
        stage('Provisioning server') {
            environment {
                AWS_ACCESS_KEY_ID = "AKIA2L42SODEJHO2PV5R"
                AWS_SECRET_KEY_ID = "G9vsPlXfAJKOFN6Ic4K9S8y006rmI/8EFmKe7xEx"
            }
            steps{
                echo 'provisining ec2 instances .. ..  ...'
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
            echo 'waiting for ec2 intances to complete initialiazation process.... ..' 

            sleep(time:90, unit: "SECONDS") 

            echo 'deploying docker image to EC2. .. . ..'

            def dockerCmd = "docker run -d -p 8080 ${IMAGE_NAME}"
            def ec2instance = "ec2-user@${EC2_LINUX_IP}"

            sshagent(['ec2-server-key']) {
                sh "ssh -o StrictHostKeyChecking=no ${ec2instance} ${dockerCmd}"

                        }
                    }   
                }
            }             
        }
    }