environment                       = "prd"
environment_code                  = "prd"
insights_account_id               = "610386461084"
tf_artifact_s3                    = "sdge-dtdes-prd-wus2-s3-tf-artifacts"
s3bucket_insights_replication_arn = "arn:aws:s3:::sdge-dmeti-prd-wus2-s3-nla-replicated-clean-data"
aws_assume_role_pii               = "arn:aws:iam::610386461084:role/fondo/sdge-dtdes-prd-iam-role-ado-beta"
aws_assume_role_insights          = "arn:aws:iam::610386461084:role/fondo/sdge-dmeti-prd-iam-role-ado-beta"
insights_s3kms_arn                = "arn:aws:kms:us-west-2:610386461084:key/789c07aa-352b-49ed-ae62-f6960eb451da" # TODO replace with correct value