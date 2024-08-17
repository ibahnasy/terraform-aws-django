Django App Deployment on AWS with Terraform

Targeting deployement of this sample app: https://github.com/uptime-com/interview-sre-pythonapp


## Architecture

This project deploys a Django application on AWS using Docker, ensuring high availability and scalability. The infrastructure is provisioned using Terraform, utilizing Elastic Load Balancing (ELB), Elastic Container Service (ECS), and Relational Database Service (RDS) with PostgreSQL.
Architecture Overview

    - Elastic Load Balancer (ELB):
      Distributes incoming traffic across multiple ECS tasks, ensuring high availability and fault tolerance.

    - Elastic Container Service (ECS): 
      Manages Docker containers running the Django application. The ECS service is configured with an Auto Scaling Group (ASG) to handle scaling based on demand.

    - Relational Database Service (RDS):
      Provides a managed PostgreSQL database, ensuring data persistence and security.

    - VPC and Networking:
      A Virtual Private Cloud (VPC) is set up with public and private subnets. ECS tasks and RDS instances are deployed in private subnets, while the ELB is in public subnets.



## Background Processing

To handle background processing for this application within the AWS environment:

    * AWS SQS (Simple Queue Service):
      Use SQS to manage task queues. A Django management command can be run in a separate ECS service that consumes messages from the SQS queue and processes them asynchronously.
    
    * Celery:
      Integrate Celery with Django for handling background jobs. 
      Run Celery workers as separate ECS tasks. These tasks can pull jobs from SQS or directly from Celery's own task queue if Redis or another broker is used.

## Scheduled Tasks

To implement scheduled tasks (e.g., cron jobs) for this application within the AWS environment:

    * AWS CloudWatch Events:
      Use CloudWatch Events (or EventBridge) to trigger scheduled tasks at predefined intervals. 
      This can invoke a Lambda function or an ECS task to run a Django management command or a custom script.
    
    * ECS Scheduled Tasks:
      Directly set up scheduled tasks in ECS using the aws_ecs_schedule resource in Terraform. 
      This allows you to run specific containers at scheduled times to handle recurring tasks, such as database cleanups or periodic data processing.


## How to Use

# Clone the repository:

git clone <repository_url>
cd terraform-django-aws

# Adding Docker image

- After creating the Docker image from the Django app, add it to AWS ECR then add it's endpoing to "docker_image_endpoint" in "terraform.tfvars" file and define the other variables.

# Initialize Terraform:

`terraform init`

# Configuration syntax check and dry-run:

`terraform plan`

# Apply the Terraform configuration:

`terraform apply`

This will provision all the necessary AWS resources and deploy the Django application.

Access the application: The DNS name of the ELB will be outputted after a successful deployment. Use it to access the application.


Notes

Ensure that the AWS CLI is configured with the necessary permissions before running Terraform commands.
You will need to adapt the Django settings to match the AWS environment, such as configuring the database connection and "ALLOWED_HOSTS".
Also should set the database endpoint URL to that provided one from Terraform after the RDS is created in the docker compose file.