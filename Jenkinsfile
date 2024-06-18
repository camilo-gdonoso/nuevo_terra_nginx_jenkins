pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Checkout Source Code') {
            steps {
                git branch: 'master', url: 'https://github.com/camilo-gdonoso/terraform_jenkins.git'
            }
        }
                stage('Prepare SSH Key') {
            steps {
                withCredentials([file(credentialsId: 'PRIVATE_KEY_AWS', variable: 'KEY_FILE')]) {
                    sh '''
                        cp $KEY_FILE ./key_pair.pem
                        chmod 600 ./key_pair.pem
                    '''
                }
            }
        }
        
        stage('Initialize Terraform') {
            steps {
                sh 'pwd'
                sh 'terraform init'
                sh 'pwd'
            }
        }
        
        stage('Format and Validate Terraform Code') {
            steps {
                sh 'terraform fmt && terraform validate'
                
            }
        }

        stage('Plan Terraform Plan') {
            steps { 
                    sh 'pwd'
                    sh 'terraform plan'
                
            }
        }
        stage('Apply Terraform Plan') {
            steps {
                    sh 'terraform apply -var-file=terraform.tfvars -auto-approve'
                
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate', allowEmptyArchive: true
            sh 'rm -f ./key_pair.pem'
        }
    }
}

