This lambda function prompting manual copying single or multiple file from source bucket to a destination bucket, and deletion of copied files from source bucket, based on a 'yes' or 'no' input provided in test event.
If want to delete the copied files from source bucket, in delete marker put 'yes'.
If don't want to delete the copied files from source bucket, in delete marker put 'no'.
If you need to copy files from or to specific folder within a bucket, ensure to update the destination prefix and source prefix in the test event.


Example of test event given below:

Example-1: If Delete marker 'yes'.
         {
  "source_bucket": "sdge-dtdes-dev-wus2-s3-nla-source-bucket",
  "destination_bucket": "sdge-dtdes-dev-wus2-s3-nla-destination-bucket",
  "source_prefix": "final-source-file/",
  "delete_marker": "yes",
  "destination_prefix": "final-destination-file/",
  "keys_to_copy": [
    "NLA_1245153_7281650703394747349_Summed.wav",
    "NLA_1245640_7319522771528127967_Summed.wav",
    "NLA_1245153_7352225936715088589_Summed.wav",
    "NLA_1245640_7319223399422705322_Summed.wav",
    "NLA_1245640_7319207460799069379_Summed.wav"
  ]
}

Example-2: If Delete marker 'no', as well as having folders in both bucket. 
             {
  "source_bucket": "sdge-dtdes-dev-wus2-s3-nla-source-bucket",
  "destination_bucket": "sdge-dtdes-dev-wus2-s3-nla-destination-bucket",
  "source_prefix": "final-source-file/",
  "delete_marker": "no",
  "destination_prefix": "final-destination-file/",
  "keys_to_copy": [
    "NLA_1245153_7281650703394747349_Summed.wav",
    "NLA_1245640_7319522771528127967_Summed.wav",
    "NLA_1245153_7352225936715088589_Summed.wav",
    "NLA_1245640_7319223399422705322_Summed.wav",
    "NLA_1245640_7319207460799069379_Summed.wav"
  ]
}

Example-3: If not haveing any folders in buckets.

         {
  "source_bucket": "sdge-dtdes-dev-wus2-s3-nla-source-bucket",
  "destination_bucket": "sdge-dtdes-dev-wus2-s3-nla-destination-bucket",
  "source_prefix": "",
  "delete_marker": "no",
  "destination_prefix": "",
  "keys_to_copy": [
    "NLA_1245153_7281650703394747349_Summed.wav",
    "NLA_1245640_7319522771528127967_Summed.wav",
    "NLA_1245153_7352225936715088589_Summed.wav",
    "NLA_1245640_7319223399422705322_Summed.wav",
    "NLA_1245640_7319207460799069379_Summed.wav"
  ]
}

Example-4: If have a folder in source bucket and not in a destination bucket.

         {
  "source_bucket": "sdge-dtdes-dev-wus2-s3-nla-source-bucket",
  "destination_bucket": "sdge-dtdes-dev-wus2-s3-nla-destination-bucket",
  "source_prefix": "final-source-file",
  "delete_marker": "no",
  "destination_prefix": "",
  "keys_to_copy": [
    "NLA_1245153_7281650703394747349_Summed.wav",
    "NLA_1245640_7319522771528127967_Summed.wav",
    "NLA_1245153_7352225936715088589_Summed.wav",
    "NLA_1245640_7319223399422705322_Summed.wav",
    "NLA_1245640_7319207460799069379_Summed.wav"
  ]
}

Example-5: If have a folder in destination bucket and not in a source bucket.

         {
  "source_bucket": "sdge-dtdes-dev-wus2-s3-nla-source-bucket",
  "destination_bucket": "sdge-dtdes-dev-wus2-s3-nla-destination-bucket",
  "source_prefix": "",
  "delete_marker": "no",
  "destination_prefix": "final-destination-file/",
  "keys_to_copy": [
    "NLA_1245153_7281650703394747349_Summed.wav",
    "NLA_1245640_7319522771528127967_Summed.wav",
    "NLA_1245153_7352225936715088589_Summed.wav",
    "NLA_1245640_7319223399422705322_Summed.wav",
    "NLA_1245640_7319207460799069379_Summed.wav"
  ]
}         