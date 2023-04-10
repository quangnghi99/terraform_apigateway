import json
import boto3


def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('student')
    response = table.update_item(
        Key={
           "id": json.loads(event['body'])['id']
        },
        UpdateExpression='SET Age= :age',
        ExpressionAttributeValues={
            ':age' : json.loads(event['body'])['Age']
        }
    )
    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'body': 'Update ' + json.loads(event['body'])['id']
    }