#!/bin/bash

## text is value of output format
aws configure --profile s3-deployer <<-EOF > /dev/null 2>&1
$S3_ACCESS_KEY
$S3_SECRET_KEY
$S3_REGION
text
EOF

aws s3 cp ./server s3://$S3_BUCKET/ --recursive --profile s3-deployer