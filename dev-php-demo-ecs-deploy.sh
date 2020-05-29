#!/bin/bash
ECR_IMAGE="700707367057.dkr.ecr.us-east-1.amazonaws.com/$1:$2"
TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition ecs-$1 --region us-east-1)
NEW_TASK_DEFINTIION=$(echo $TASK_DEFINITION | jq --arg IMAGE "$ECR_IMAGE" '.taskDefinition | .containerDefinitions[0].image = $ECR_IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities)')
echo "$NEW_TASK_DEFINTIION"
NEW_TASK_DEFINTIION=`echo $NEW_TASK_DEFINTIION | sed 's/\\r//g'`
echo "$NEW_TASK_DEFINTIION"
NEW_TASK_INFO=$(aws ecs register-task-definition --region us-east-1 --cli-input-json "$NEW_TASK_DEFINTIION")
NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')
aws ecs update-service --cluster ecs-cluster --service ecs-$1 --task-definition ecs-$1:${NEW_REVISION} --region us-east-1
