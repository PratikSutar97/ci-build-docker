## CodeBuild Create Docker Images and Push it to ECR

This Project will create Docker Images and push the Docker Images to Amazon ECR repository.
### Pre-requisites
- Create two SSM Parameters and store the https Git Credentials for an IAM user.
- This will be used in CodeBuild Project e.g (git-username and git-password)
- Create a Github repository and upload the files using git bash and other git commands like git add, git commit and git
- Create a Codebuild Project from AWS Console with below information:
    - For Operating system, choose Ubuntu.
    - For Runtime, choose Standard.
    - For Image, choose aws/codebuild/standard:5.0.
    - Since we have to use this build project to build a Docker image, select `Privileged` checkbox.
    - Add below Environment Variables for CodeBuild.
      - `SDLC_ENVIRONMENT` as CodeBuild Project Environment Variable
      - `IMAGE_REPO_NAME ` : `docker-sample-ecr-repo`
      - `IMAGE_TAG` : `latest`
      - `AWS_ACCOUNT_ID` : <account-ID>
>Privileged :Enable this flag if you want to build Docker images or want your builds to get elevated privileges.
- Add below inline policy to Codebuild Project Role.
```
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
        "ecr:CreateRepository",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
        "ecr:DescribeRepositories",
        "ssm:Describe*",
        "ssm:Get*",
        "ssm:List*"
      ],
    "Resource": "*"
  }]
}
```

- Create a CodePipeline with Source Stage as Github and Build Stage as CodeBuild, while creating the CodePipeline, a Cloudwatch event will be created , where any change to the master branch will trigger the Pipeline.

#### Repository structure
----------------------------
 - `config` - contains `buildspec.yml` file that will be used by CodeBuild Project
- `model1` - contains code for particular ML algorithm along with shell script(to build and push docker image to ECR Repository) and Dockerfile.
- `model2` - same as `model1` but contains slight changes for Dockerfile
- `scripts` - contains `utility-script.sh` that has code related to executing particular docker build as per commit id specified.