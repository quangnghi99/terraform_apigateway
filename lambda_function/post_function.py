import boto3

def lambda_handler(event, context):
   client = boto3.resource('dynamodb')
   table = client.Table('student')
   response = table.put_item(
       Item={
           'id': event['id'],
           'Name': event['Name'],
           'Age': event['Age'],
           'Gender': event['Gender'],
           'Location': event['Location']
       }
   )
   return {
       'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
       'body': 'Record ' + event['id'] + ' added'
   }