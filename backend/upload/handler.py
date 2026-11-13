
import json
import os
import uuid

import boto3
from botocore.config import Config


s3 = boto3.client("s3", config=Config(signature_version="s3v4"))

BUCKET_NAME = os.environ.get("DOCUMENT_BUCKET")
MAX_FILE_SIZE = 5 * 1024 * 1024


def lambda_handler(event, context):
    if not BUCKET_NAME:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Storage is not configured"
            })
        }

    # Read the identity verified by API Gateway
    claims = (
        event.get("requestContext", {})
        .get("authorizer", {})
        .get("jwt", {})
        .get("claims", {})
    )

    user_id = claims.get("sub")

    # Reject requests without an authenticated user identity
    if not isinstance(user_id, str) or not user_id:
        return {
            "statusCode": 403,
            "body": json.dumps({
                "message": "Not authorised"
            })
        }

    # Keep each user's uploads under their own S3 prefix
    object_key = f"uploads/{user_id}/{uuid.uuid4()}.pdf"

    # Generate a short-lived upload form
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
