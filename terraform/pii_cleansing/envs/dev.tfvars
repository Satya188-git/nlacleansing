environment                       = "dev"
environment_code                  = "dev"
insights_account_id               = "713342716921"
tf_artifact_s3                    = "sdge-dtdes-dev-wus2-s3-tf-artifacts"
s3bucket_insights_replication_arn = "arn:aws:s3:::sdge-dmeti-dev-wus2-s3-nla-replicated-clean-data"
# aws_assume_role_pii               = "arn:aws:iam::183095018968:role/fondo/sdge-dtdes-dev-iam-role-ado-beta"
# aws_assume_role_insights          = "arn:aws:iam::713342716921:role/fondo/sdge-dmeti-dev-iam-role-ado-beta"
insights_s3kms_arn                = "arn:aws:kms:us-west-2:713342716921:key/789c07aa-352b-49ed-ae62-f6960eb451da"
audioaccessnotificationemail	  = "SShirsat@sdgecontractor.com"
supervisordatanotificationemail	  = "SShirsat@sdgecontractor.com"
nlaaudioaccessnotificationemail   = "SShirsat@sdgecontractor.com"
oidc_iam_role_name                = "sdge-dtdes-dev-terraform-oidc-role"
nla_insights_historic_call_lambda_arn = "arn:aws:lambda:us-west-2:713342716921:function:sdge-dmeti-dev-wus2-lambda-historic-call"