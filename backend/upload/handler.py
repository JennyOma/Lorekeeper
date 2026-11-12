
import json
import os
import uuid

import boto3
from botocore.config import Config

# AWS S3 client
s3 = boto3.client(
    "s3",
    config=Config(signature_version="s3v4")
)

BUCKET_NAME = os.environ.get("DOCUMENT_BUCKET")
MAX_FILE_SIZE = 5 * 1024 * 1024  # 5 MB


def lambda_handler(event, context):
    # Start with one supported document type: PDF.
    # API Gateway authentication must be enforced
    # before this function is publicly accessible.

    if not BUCKET_NAME:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Storage is not configured"
            })
        }

    # Generate a unique object name.
    # Never use personal information in filenames.
    object_key = f"uploads/{uuid.uuid4()}.pdf"

    # Generate a short-lived, restricted upload form.
    upload = s3.generate_presigned_post(
        Bucket=BUCKET_NAME,
        Key=object_key,
        Fields={
            "Content-Type": "application/pdf"
        },
        Conditions=[
            {"Content-Type": "application/pdf"},
            ["content-length-range", 1, MAX_FILE_SIZE]
        ],
        ExpiresIn=300
    )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "upload": upload,
            "document_id": object_key.split("/")[-1],
            "expires_in": 300
        })
    }
