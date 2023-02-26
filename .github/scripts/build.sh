#!/bin/bash

sed -i 's/<S3_ACCESS_KEY>/$S3_ACCESS_KEY/g;s/<S3_SECRET_KEY>/$S3_SECRET_KEY/g' ./agent/core-site.xml