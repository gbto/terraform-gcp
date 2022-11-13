#!/bin/bash
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# This script creates a bucket to store terraform states
# Syntax: create-tf-state-bucket.sh [-e environemnt] [-p gcp project] [-c storage class] [-r retention] [-b bucket name]

# Declare default arguments
ENV="dev"
PROJECT_ID="gbto-dev"
STORAGE_CLASS="standard"
RETENTION=30
BUCKET_NAME="gbto-tfstates"

# Parse user arguments
while getopts e:p:c:r:b: option; do
    case "${option}" in
    e) ENV=${OPTARG} ;;
    p) PROJECT_ID=${OPTARG} ;;
    c) STORAGE_CLASS=${OPTARG} ;;
    r) RETENTION=${OPTARG} ;;
    b) BUCKET_NAME=${OPTARG} ;;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
    esac
done

# Warn for missing parameters
if [[ -z $ENV ]] || [[ -z $PROJECT_ID ]] || [[ -z $STORAGE_CLASS ]] || [[ -z $RETENTION ]] || [[ -z $BUCKET_NAME ]]; then
    echo "ERROR: Some required parameters are missing. Verify that you've passed correctly an ENV, PROJECT, RETENTION and BUCKET. Exiting script."
    exit 1
elif gsutil ls -p gbto-dev gs://gbto-tfstates 2>/dev/null; then
    echo "The bucket already exists, re-creating it would erase its content. Exiting script."
    exit 1
else
    # Printing passed parameters
    echo "Initializing creation of the bucket with the following parameters:"
    echo "environment: $ENV"
    echo "gcp project: $PROJECT_ID"
    echo "storage class: $STORAGE_CLASS"
    echo "terraform bucket name: $BUCKET_NAME"

    # Create bucket
    gcloud storage buckets create gs://$BUCKET_NAME \
     --project=$PROJECT_ID \
     --default-storage-class=${STORAGE_CLASS} \
     --location=europe-west1 \
     --uniform-bucket-level-access

    echo "Created $BUCKET bucket succesfully in project $PROJECT_ID"
fi
