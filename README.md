<!-- @format -->

# Apache Flume Ingestor

Apache Flume Ingestor is a proof of concept data pipeline. The pipeline consists of the following

1. Apache Flume
2. AWS S3
3. AWS Lambda
4. An Express server running on AWS EC2 instance

For devops/infrastructure management, the following were used

1. Terraform
2. Docker
3. Github Actions

## Data Pipeline

### 1. Apache Flume to AWS S3

Getting Apache Flume to send data to S3 is a matter of configuration. In the
_agent/agent.conf_ you will see Apache Flume agent configured to receive data
via netcat and http.

There were two challenges in sending data to S3.

1. Running Apache Flume
2. Duplicate .tmp files in S3

When running Apache Flume agent, it tended to die when trying to send data to S3.
Lack of familiarity with JVM made finding a solution to this harder than it should
have been.The solution was simply increasing the minimum JVM heap size from 100MB
to 524MB.

There were duplicate files with .tmp extension in S3.Investigated this while thinking
it was due to an error/misconfiguration.It is apparently due a [bug](https://issues.apache.org/jira/browse/FLUME-2445) in
Apache Flume.

### 2. AWS S3 to AWS Lambda Function

This was the easiest step in the project.When Apache Flume sends a file to S3
then an `s3:ObjectCreated:\*` is sent to the Lambda Function.

When creating the Lambda Function, it is configured to listen `s3:ObjectCreated:\*`
events and execute.

### 3. AWS Lambda to EC2 Server

After receiving the `s3:ObjectCreated:\*` event, the Lambda function relays that
to the EC2 server via an HTTP POST call. The payload of the call only has
the s3 bucket name and the key of the object created.

The EC2 server simply listens for HTTP POST calls, and downloads the object
in the POST call data from S3. Nothing is done with the downloaded object.

## DevOps/Infrastructure

### 1. Terraform

There is a terraform plan to provision an EC2 instance, a Lambda function,
and VPC. The plan also configures the S3 bucket to send events to Lambda function
and to start the EC2 with a certain key. The EC2 key is to enable one to ssh
into the running instance.

To avoid deploying the server code to the EC2 instance, an AMI was created from
an EC2 instance that was already set-up to have everything necessary.It is this
AMI that the terraform plan use to provision an EC2 instance.

The EC2 instance and Lambda function are in the same VPC, which allows the Lambda
function to use static private IP of the EC2 instance to connect to it when
making the HTTP POST calls.

### 2. Docker

A Docker image was created for the Apache Flume agent to avoid installing unnecessary
applications on local dev machine. The image is deployed to DockerHub.

### 3. Github Actions

A GitHub action is used to build the Apache Flume agent image and deploy it DockerHub.
During the build process the S3 access token and secret key are injected in the
_core-site.xml_. It is best to store secrets in a secrets manager, but that secrets
are "safe enough" in Github.
