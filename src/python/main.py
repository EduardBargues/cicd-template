import json


def handler(event, context):
    print("PYTHON LAMBDA EXECUTION")
    return {
        "statusCode": 200,
        "headers": {},
        "body": "python-lambda",
        "isBase64Encoded": False,
    }
