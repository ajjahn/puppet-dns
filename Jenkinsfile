def SUFFIX = ''

pipeline {
    agent any

    parameters {
        string (name: 'VERSION_PREFIX', defaultValue: '0.0.0', description: 'puppet-dns version')
    }
    environment {
        BUILD_TAG = "${env.BUILD_TAG}".replaceAll('%2F','_')
        BRANCH = "${env.BRANCH_NAME}".replaceAll('/','_')
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
    }
    stages {
        stage ('Use the Puppet Development Kit Validation to Check for Linting Errors') {
            steps {
                sh 'pdk validate'
            }
        }
        stage ('Use the Puppet Development Kit Test Unit for Module Unit Testing) {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'pdk test -d unit'
            }
        }
        stage ('Checkout and build puppet-dns in Docker to validate code as well as changes across OSes.') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                dir("${env.WORKSPACE}") {
                    sh 'docker build -t ppouliot/puppet-dns .'
                }
            } 
        }
        stage ('Checkout and build puppet-dns in Vagrant to assemble a functional IPAM cluster') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                dir("${env.WORKSPACE}") {

                    sh 'vagrant up'
                }
            } 
        }
        
        stage ('Cleanup vagrant after successful build.') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'vagrant destroy -f'
            }
        }


        stage ('Organize files') {
            steps {
                sh ''
            }
        }

        stage ('Code signing') {
            steps {
                sh ''
            }
        }
        stage ('Upload to GitHub') {
            steps {
                sh ''
            }
        }

    } 
}
