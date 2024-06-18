import json
import boto3
import os
import logging
logger = logging.getLogger()
logger.setLevel("INFO")


# Python boto3 logic to process SNS messages from topic defined in environment variable subscribed_sns_topic_arn and forwards the exact same content to SNS topic defined in environment variable target_sns_topic_arn
def lambda_handler(event, context):
    logger.info(json.dumps(event))
    sns = boto3.client('sns')
    target_sns_topic_arn = os.environ['target_sns_topic_arn']
    subscribed_sns_topic_arn = os.environ['subscribed_sns_topic_arn']

    if not event.get('Records'):
        logger.error("No Records found in event")
        return {
            'statusCode': 200,
            'body': json.dumps('No Records found in event')
        }

    for record in event['Records']:
        payload = json.dumps(record)
        logger.info("Publishing message to SNS topic {target_sns_topic_arn}: {payload}")
        sns.publish(TopicArn=target_sns_topic_arn, Message=payload)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
