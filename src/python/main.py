import json


def handler(event, context):
    print(f'''NODEJS LAMBDA EXECUTION
    request-id: {event['requestContext']['requestId']}
    aws-request-id: {context.aws_request_id}''')
    return {
        "statusCode": 200,
        "headers": {},
        "body": "python-lambda",
        "isBase64Encoded": False,
    }
