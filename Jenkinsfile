//pipeline na deploy do DEV
void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/martinmlkvy/ditec-cicd"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

pipeline{
    agent any

    environment { 
        NAMESPACE = "ditec-cicd-jenkins"
    }

    stages{
        stage("Test"){
            steps{
                echo "testujem aplikaciu"
            }           
        }

        stage("Build image and push to quay"){
            steps{
                script{
                    try {
                        sh 'oc delete buildconfig testapp-bc -n ${NAMESPACE}'
                    }
                    catch (Exception e) {
                        echo 'buildconfig does not exists ===>' + e.toString()
                    }
                    sh '''
                        ./build-config.sh ${BUILD_NUMBER} ${NAMESPACE}
                        oc start-build testapp-bc --follow --wait -n ${NAMESPACE}
                    '''
                }                
            }           
        }
        
        stage("Deploy pouzitim imagestream"){
            steps{
                sh '''
                    oc tag quay.io/cerveny/ditec-cicd:jenkins-verzia-${BUILD_NUMBER} docker-testapp-is:latest -n ${NAMESPACE}
                '''
            }
        }
    }

    post {
        success {
            setBuildStatus("Build succeeded", "SUCCESS");
        }
        failure {
            setBuildStatus("Build failed", "FAILURE");
        }
    }
}