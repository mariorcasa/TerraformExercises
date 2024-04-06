## S3BucketRemoteState: Configuring an S3 Bucket with Remote State

### Instructions:
Using Terraform, create a script that configures an S3 storage bucket on AWS to store the Terraform state remotely.

### Requirements:
- The bucket must have a globally unique name. ✅
- Configure a policy block to restrict access to the bucket. ✅
- Assign a tag to the bucket. ✅
- Use the configured S3 bucket to store the Terraform state remotely. ✅

## Commands:
- aws configure
- aws s3api create-bucket --bucket terraform-example-test-1 --region us-east-1 --object-lock-enabled-for-bucket
- aws dynamodb create-table --table-name remote-state-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --billing-mode PROVISIONED
- terraform init
- terraform plan 
- terraform force-unlock <ID retorned in the last command in Lock Info>
- terraform plan
- terraform apply
- (Validate AWS S3 terraform created in the s3api command, file in: state/terraform.tfstate)
- terraform destroy
- aws s3api delete-objects --bucket terraform-example-test-1 --delete "$(aws s3api list-object-versions --bucket "terraform-example-test-1" --output=json --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"
- aws s3api delete-objects --bucket terraform-example-test-1 --delete "$(aws s3api list-object-versions --bucket "terraform-example-test-1" --output=json --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')"
- aws s3api delete-bucket --bucket terraform-example-test-1
- aws dynamodb delete-table --table-name remote-state-lock

## References:
- https://stackoverflow.com/questions/69813206/how-to-empty-s3-bucket-using-aws-cli
- https://docs.aws.amazon.com/cli/latest/reference/dynamodb/#cli-aws-dynamodb
- https://docs.aws.amazon.com/cli/latest/reference/s3api/#cli-aws-s3api
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
- https://developer.hashicorp.com/terraform/language/settings/backends/s3