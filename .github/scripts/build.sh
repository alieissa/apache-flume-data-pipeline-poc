#!/bin/bash

sed -i 's/<S3_ACCESS_KEY>/${secrets.S3_ACCESS_KEY}/g;s/<S3_SECRET_KEY>/${secrets.S3_SECRET_TOKEN}/g' ./app/core-site.xml