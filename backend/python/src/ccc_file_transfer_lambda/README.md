This lambda function prompting manual copying files from source bucket to a destination bucket, and deletion of copied file from source bucket, based on a 'yes' or 'no' input provided in test event.
If want to delete the copied file from source bucket, in delete response put 'yes'.
If don't want to delete the copied file from source bucket, in delete response put 'no'.
If you need to copy files from or to specific folder within a bucket, ensure to update the destination prefix and source prefix in the test event.