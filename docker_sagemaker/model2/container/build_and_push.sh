#!/bin/bash

# This script shows how to build the Docker image and push it to ECR to be ready for use
# by SageMaker.

# The argument to this script is the image name. This will be used as the image on the local
# machine and combined with the account and region to form the repository name for ECR.
#Algorithm Name will be the Reposistory Name that is passed as a command line parameter.
echo "Inside build_and_push.sh filesss"
SDLC_ENVIRONMENT=$1
image=$2
echo "this is written after tag push v1.0.0"
echo "value of image is $image"

if [ "$image" == "" ]
then
    echo "Usage: $0 <image-name>"
    exit 1
fi
src_dir=$CODEBUILD_SRC_DIR
chmod +x $image/container/linear_learner/train
chmod +x $image/container/linear_learner/serve

# Get the account number associated with the current IAM credentials
account=$(aws sts get-caller-identity --query Account --output text)

if [ $? -ne 0 ]
then
    exit 255
fi

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$AWS_REGION
echo "Region value is : $region"
# If the repository doesn't exist in ECR, create it.
ecr_repo_name=$image"-ecr-repo"
aws ecr describe-repositories --repository-names ${ecr_repo_name} --region $region || aws ecr create-repository --repository-name ${ecr_repo_name} --region $region
# aws ecr describe-repositories --repository-names "${ecr_repo_name}" --query repositories[*].[repositoryUri] --output text
# aws ecr describe-repositories --repository-names "${ecr_repo_name}" > /dev/null 2>&1
# if [ $? -ne 0 ]
# then
#     aws ecr create-repository --repository-name "${ecr_repo_name}" > /dev/null
#     echo "Repository ${ecr_repo_name} is created."
# fi
# today=`date +%Y-%m-%d-%H-%M-%S`
# image_name=$image-$today
image_name=$SDLC_ENVIRONMENT-$image-$CODEBUILD_BUILD_NUMBER

# Get the login command from ECR and execute it directly
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin ${account}.dkr.ecr.${region}.amazonaws.com

fullname="${account}.dkr.ecr.${region}.amazonaws.com/${ecr_repo_name}:$image_name"
echo "fullname is $fullname"
# Build the docker image locally with the image name and then push it to ECR with the full name.

#docker build -t ${image_name} .
#docker build -t ${image_name} $image/container/
docker build -t ${image_name} $image/container/
echo "Docker build after"

echo "image_name is $image_name"
docker tag ${image_name} ${fullname}

docker push ${fullname}
echo "Docker Push Event is successfull with ${fullname}"
