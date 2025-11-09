#!/usr/bin/env groovy

// pipeline {
//     agent any
//     environment {
//         AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
//         AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
//         AWS_DEFAULT_REGION = "us-east-1"
//     }
//     stages {
//         stage("Create an EKS Cluster") {
//             steps {
//                 script {
//                     dir('terraform') {
//                         sh "terraform init"
//                         sh "terraform apply -auto-approve"
//                     }
//                 }
//             }
//         }
//         stage("Deploy to EKS") {
//             steps {
//                 script {
//                     dir('kubernetes') {
//                         sh "aws eks update-kubeconfig --name my-eks-cluster --region us-east-1"
//                         sh "kubectl apply -f nginx-deployment.yaml"
//                         sh "kubectl apply -f nginx-service.yaml"
//                     }
//                 }
//             }
//         }
//     }
// }




pipeline {
    agent any
    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select the Terraform action: apply or destroy.'
        )
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        if (params.ACTION == 'apply') {
                            // Apply the saved plan file
                            echo "Applying infrastructure changes..."
                            sh 'terraform apply -auto-approve tfplan'
                        } else if (params.ACTION == 'destroy') {
                            // Destroy the infrastructure
                            echo "!!! DESTROYING INFRASTRUCTURE !!!"
                            sh 'terraform destroy -auto-approve'
                        } else {
                            error "Invalid action selected: ${params.ACTION}"
                        }
                    }
                }
            }
        }
        stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name my-eks-cluster --region us-east-1"
                        sh "kubectl apply -f nginx-deployment.yaml"
                        sh "kubectl apply -f nginx-service.yaml"
                    }
                }
            }
        }
    }
}