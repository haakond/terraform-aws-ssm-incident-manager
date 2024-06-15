import json
import boto3
import os
import logging
logger = logging.getLogger()
logger.setLevel("INFO")

# Python boto3 logic to process SNS messages from topic defined in environment variable subscribed_sns_topic_arn and forwards the exact same content to SNS topic defined in environment variable target_sns_topic_arn

def lambda_handler(event, context):
    logger.info(json.dumps(event))
