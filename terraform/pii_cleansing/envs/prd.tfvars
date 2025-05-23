environment                       = "prd"
environment_code                  = "prd"
insights_account_id               = "610386461084"
tf_artifact_s3                    = "sdge-dtdes-prd-wus2-s3-tf-artifacts"
s3bucket_insights_replication_arn = "arn:aws:s3:::sdge-dmeti-prd-wus2-s3-nla-replicated-clean-data"
# aws_assume_role_pii               = "arn:aws:iam::853670940162:role/fondo/sdge-dtdes-prd-iam-role-ado-beta"
#aws_assume_role_insights          = "arn:aws:iam::610386461084:role/fondo/sdge-dmeti-prd-iam-role-ado-beta"
insights_s3kms_arn                    = "arn:aws:kms:us-west-2:610386461084:key/c467e64b-2e9e-4fd5-9d8c-adeca264a741"
audioaccessnotificationemail          = "ACC-SDGE-PERSISTENT-TEAM@accenture.com"
supervisordatanotificationemail       = "ACC-SDGE-PERSISTENT-TEAM@accenture.com"
nlaaudioaccessnotificationemail       = "ACC-SDGE-PERSISTENT-TEAM@accenture.com"
oidc_iam_role_name                    = "sdge-dtdes-prd-terraform-oidc-role"
nla_insights_historic_call_lambda_arn = "arn:aws:lambda:us-west-2:610386461084:function:sdge-dmeti-prd-wus2-lambda-historic-call"
athena_access_role                = "arn:aws:iam::853670940162:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_sdge-dtdes-prd-developer_0c9b1033730bf6f5"
