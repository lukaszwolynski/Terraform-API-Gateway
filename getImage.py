import base64
import boto3
import json
import random
import botocore
import os
s3 = boto3.client('s3')
bucket = os.getenv('bucketName')


def get_s3_keys(bucket):
    """Get a list of keys in an S3 bucket."""
    keys = []
    resp = s3.list_objects_v2(Bucket=bucket)
    for obj in resp['Contents']:
        keys.append(obj['Key'])
    
    return keys
    

def lambda_handler(event, context):
    keys = get_s3_keys(bucket)

    response = s3.get_object(
            Bucket=bucket,
            Key=keys[random.randint(0,len(keys)-1)],
        )
    image = response['Body'].read()
    return {
            'headers': { "Content-Type": "image/png", 
                        "Content-Type": "image/jpg"
            },
            'statusCode': 200,
            'body': base64.b64encode(image).decode('utf-8'),
            'isBase64Encoded': True
        }
    