## MicroserviceArchitectureWithECS: Implementing a Microservices Architecture in AWS ECS

### Instructions:
Using Terraform, create a script that implements a microservices architecture in AWS ECS (Elastic Container Service).

### Requirements:
- Define two microservices that allow intercomunication from messages using AWS SQS (Decouple) ✅
- Define an ECS container cluster with multiple services.
- Configure a Network Load Balancer to distribute traffic among containers.
- Utilize AWS Fargate to manage container infrastructure without provisioning EC2 instances.
- Implement automatic scaling policies for ECS services based on performance metrics.

## Commands (Docker Composer - Only Local):
- aws configure
- aws configure export-credentials
- ren .env.dev .env / Rename-Item -Path .env.dev -NewName .env / mv .env.dev .env
- (edit .env file with all data)
- docker compose up --build
- http://localhost:3000/sender1
- Wait 5 or 10 seconds and see log

## References:
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/configure/export-credentials.html
- https://docs.docker.com/reference/cli/docker/compose/up/
- https://docs.aws.amazon.com/ses/latest/dg/Welcome.html