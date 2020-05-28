def allServices=["gateway", "users", "plans", "integrations", "php-demo"]
//def gatewayService=["gateway"]
//def usersService=["users"]
//def plansService=["plans"]
//def integrationsService=["integrations"]
def phpDemoService = [allServices[4]]

def parallelStagesMap = allServices.collectEntries {
    ["${it}" : generateStage(it)]
}

//def gatewayStagesMap = gatewayService.collectEntries {
//    ["${it}" : generateStage(it)]
//}

//def usersStagesMap = usersService.collectEntries {
//    ["${it}" : generateStage(it)]
//}

//def plansStagesMap = plansService.collectEntries {
//    ["${it}" : generateStage(it)]
//}

//def integrationsStagesMap = integrationsService.collectEntries {
//    ["${it}" : generateStage(it)]
//}

def phpDemoStagesMap = phpDemoService.collectEntries {
    ["${it}" : generateStage(it)]
}

branchName = "${env.BRANCH_NAME}"
tagName = ""
if(branchName == "master")
	tagName = "latest"
else tagName = branchName.replaceAll("/","-")
		
def generateStage(service) {
    return {
      stage("Build ${service}"){
	      echo "Building ${service}"
	      sh "docker build --no-cache -t 700707367057.dkr.ecr.us-east-1.amazonaws.com/${service}:${tagName} -f Dockerfile ."
      }
      stage("Push ${service}"){
              sh "eval \$(aws ecr get-login --no-include-email --region us-east-1)"
              sh "docker push 700707367057.dkr.ecr.us-east-1.amazonaws.com/${service}:${tagName}"
      }
      stage("Deploy ${service}"){
        if(branchName == "master"){
	     // Define Variable
             def USER_INPUT = input(
                    message: 'Do you want to deploy to production?',
                    parameters: [
                       booleanParam(defaultValue: false, description: 'Please Confirm', name: 'Deploy')
                    ])

            echo "The answer is: ${USER_INPUT}"

            if( "${USER_INPUT}" == true){
                //deploy to eks cluster
            } else {
                echo 'production deployment aborted'
            }
        }
        else{
            //sh "chmod +x ./dev-php-demo-ecs-deploy.sh"
	    sh "bash ./dev-php-demo-ecs-deploy.sh ${service} ${tagName}"
        }
      }
    }
}

pipeline {
    agent any
    parameters {
        choice(name: 'DockerImage', choices: ['All', allServices[0], allServices[1], allServices[2], allServices[3], allServices[4]], description: 'Select a docker image to build')
    }
    stages {
        stage('parallel stage') {
            steps {
                script {
                  if(params.DockerImage == 'All'){
                    parallel parallelStagesMap
                  }
                  else{
		     echo "Calling generateStage"			  
                     parallel phpDemoStagesMap
			  //def singleStage = { ["${params.DockerImage}" : generateStage(params.DockerImage)] }
		     echo "End Calling generateStage"	
                  }
                }
            }
        }
        stage('CleanWorkspace') {
            steps {
                cleanWs()
            }
        }
        stage('CleanSystem') {
            steps {
                sh "docker system prune --force"
            }
        }
    }
	
    post { 
	    //https://www.jenkins.io/doc/book/pipeline/syntax/
	    //https://applitools.com/blog/how-to-update-jenkins-build-status-in-github-pull-requests-step-by-step-tutorial/
        success { 
            echo 'build success! sending the status to github'
	    script {
		    sh 'curl -v -H \"Content-Type: application/json\" -H \"Authorization: token ${GIT_PAT}\" -X POST -d \"{\\"state\\": \\"success\\",\\"context\\": \\"continuous-integration/jenkins\\", \\"description\\": \\"Jenkins build failed\\", \\"target_url\\": \\"http://34.224.62.112:8080/job/multibranch-docker-pipeline-ci-cd/$BUILD_NUMBER/console\\"}\" \"https://api.GitHub.com/repos/rezoan/docker-pipeline-demo/statuses/$GIT_COMMIT\" '
		}
	    

        }
	failure { 
            echo 'build failure! sending the status to github'
	     script {
		     sh 'curl -v -H \"Content-Type: application/json\" -H \"Authorization: token ${GIT_PAT}\" -X POST -d \"{\\"state\\": \\"failure\\",\\"context\\": \\"continuous-integration/jenkins\\", \\"description\\": \\"Jenkins build failed\\", \\"target_url\\": \\"http://34.224.62.112:8080/job/multibranch-docker-pipeline-ci-cd/$BUILD_NUMBER/console\\"}\" \"https://api.GitHub.com/repos/rezoan/docker-pipeline-demo/statuses/$GIT_COMMIT\" '
		}

        }
	//unsuccessful { 
        //    echo 'I will always say Hello again!'
        //}
    }
}

/*
=================================================================================

pipeline {
  agent any
  parameters {
        //string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        //text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        //booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'DockerImage', choices: ['All', 'Dockerfile', 'gateway', 'users', 'plans', 'integrations'], description: 'Select a docker image to build')
   }
   stages {
    stage('Build Docker image') {
      steps{
        script {
          //echo "Hello ${params.PERSON}"

                //echo "Biography: ${params.BIOGRAPHY}"

                //echo "Toggle: ${params.TOGGLE}"

          echo "Selectd Docker Image: ${params.DockerImage}"
          if(params.DockerImage == 'All'){
            echo 'All has been selected';
          }
          else if(params.DockerImage == 'Dockerfile'){
            echo 'Dockerfile has been selected';
          }
          else{
            sh "docker build --no-cache -t 700707367057.dkr.ecr.us-east-1.amazonaws.com/php-demo:latest -f Dockerfile ." 
            sh "docker images"
          }
        }
      }
    }
     stage('Push Docker image') {
       steps{
        script {
          sh "eval \$(aws ecr get-login --no-include-email --region us-east-1)"
          sh "docker push 700707367057.dkr.ecr.us-east-1.amazonaws.com/php-demo:latest"
       }
      }
    }
     stage('Deploy Docker image') {
       steps{
        script {
	 sh "chmod +x ./dev-php-demo-ecs-deploy.sh"
         sh "./dev-php-demo-ecs-deploy.sh"
       }
      }
    }    
  }
}
*/
