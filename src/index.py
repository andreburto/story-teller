import boto3
import os
import logging
import sys

__author__ = "Andy B"

# Global variables used in functions below.
APP_NAME = "story-teller"
OPENAI_API_KEY = f"/${APP_NAME}/openai_api_key"

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(stream=sys.stdout))


def load_openai_api_key():
    client = boto3.client("ssm")
    response = client.get_parameter(Name=OPENAI_API_KEY, WithDecryption=True)
    return response["Parameter"]["Value"]


def handler(event, context) -> str:
    lambda_name = os.getenv("LAMBDA_NAME")
    logger.info(f"This is a test by {lambda_name}.")
    logger.info(f"event: {event}.")
