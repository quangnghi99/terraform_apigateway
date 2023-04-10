import boto3
import json

def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('student')
    response = table.get_item(
        Key={
           'id': event['queryStringParameters']['id']
        }
    )
    student = response['Item']
    return {
       'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
       'body': json.dumps(student)
   }