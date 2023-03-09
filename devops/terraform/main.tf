module "iam" {
  source = "./modules/iam"
}
module "kms" {
  source = "./modules/kms"
  unrefinedLambdaRole-arn = module.iam.transcribe_lambda_role-arn
  initialLambdaRole-arn = module.iam.comprehend_lambda_role-arn
  cleanLambdaRole-arn = module.iam.macie_lambda_role-arn
  dirtyLambdaRole-arn = module.iam.macie_lambda_role-arn
}
module "lambda" {
  source                                        = "./modules/lambda"
}
module "s3" {
  source                                        = "./modules/s3"
  environment                                   = var.environment
  kms_key_ccc_unrefined-arn                     = module.kms.kms_key_ccc_unrefined-arn
  kms_key_ccc_initial-arn                       = module.kms.kms_key_ccc_initial-arn
  kms_key_ccc_clean-arn                         = module.kms.kms_key_ccc_clean-arn
  kms_key_ccc_dirty-arn                         = module.kms.kms_key_ccc_dirty-arn
}