def SUFFIX = ''

pipeline {
    agent any

    parameters {
        string (name: 'VERSION_PREFIX', defaultValue: '0.0.0', description: 'puppet-dns version')
    }
    environment {
        BUILD_TAG = "${env.BUILD_TAG}".replaceAll('%2F','_')
        BRANCH = "${env.BRANCH_NAME}".replaceAll('/','_')
        BEAKER_PUPPET_COLLECTION = "puppet6"
        BEAKER_PUPPET_VERSION = "6"
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

        stage ('Use the Puppet Development Kit To run Beaker Acceptance Tests) {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'pdk bundle exec rake beaker:default'
            }
        }

        stage ('Cleanup Acceptance Tests after successful build.') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'pdk bundle exec rake module:clean'
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
