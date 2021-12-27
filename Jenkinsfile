pipeline {
    agent any

    stages {
        stage('Check Basic') {
            steps {
                sh 'git submodule init'
                sh 'git submodule update'
                sh 'make clean'
                sh 'make fmt'
                sh 'make clippy'
            }
        }

        stage('Check Release') {
            steps {
                sh 'make release'
            }
        }
    }
}