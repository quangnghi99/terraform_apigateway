import json
import boto3

def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('student')
    response = table.delete_item(
        Key ={
            "id":  event['queryStringParameters']['id']
        },
    )

    return {
    'statusCode': 200,
    'body': 'Delete ' + event['queryStringParameters']['id']
    }