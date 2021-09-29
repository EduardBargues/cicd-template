# Simple function which returns message as pong in json
def ping_pong(event, context):
    response = {
        "statusCode": 200,
        "body": {"message": "pong"}
    }
    return response
