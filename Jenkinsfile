pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-credentials')
    }

    stages {

        stage('Terraform Provision') {
            steps {
                dir('terraform') {
                    sh 'brew install terraform'
                    sh 'terraform init'

                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Prepare for Ansible') {
            steps {
                script {
                    def serverIp = sh(script: 'cd terraform && terraform output -raw instance_public_ip', returnStdout: true).trim()
                    
                    echo "Server IP found: ${serverIp}"
                    dir('ansible') {
                        writeFile(
                            file: 'inventory.ini', 
                            text: """
[servers]
${serverIp}

[servers:vars]
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
"""
                        )
                        echo "Ansible inventory.ini created successfully."
                    }
                }
            }
        }
        stage('Ansible Configuration') {
            steps {
                dir('ansible') {
                    sh 'brew install ansible'
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh 'ansible-playbook -i inventory.ini playbook.yml --private-key $SSH_KEY'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline has finished.'
        }
    }
}