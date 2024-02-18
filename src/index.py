import boto3
import datetime
import openai
import logging
import sys

__author__ = "Andy B"

# Global variables used in functions below.
APPLICATION_NAME = "story-teller"
MODEL_NAME = "gpt-4-turbo-preview"
TABLE_NAME = "story-teller-table"
# SSM parameter paths.
API_KEY_PATH = f"/{APPLICATION_NAME}/openai_api_key"
EMAIL_ADDRESS_PATH = f"/{APPLICATION_NAME}/email_address"
PROMPT_KEY_PATH = f"/{APPLICATION_NAME}/prompt_key"

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(stream=sys.stdout))


def get_ssm_parameter_by_key(ssm_key_path) -> str:
    """
    Fetches the OpenAI API key from the AWS Systems Manager Parameter Store based on the path
    setup earlier in the code.
    """
    client = boto3.client("ssm")
    response = client.get_parameter(Name=ssm_key_path, WithDecryption=True)
    return response["Parameter"]["Value"]


def get_prompt_from_dynamo_table(prompt_key: str) -> str:
    """
    Fetches the prompt from the DynamoDB table.
    """
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table(TABLE_NAME)
    response = table.get_item(Key={"Character": prompt_key})
    return response.get("Item")


def send_prompt_to_openai(openai_key: str, prompt: dict) -> str:
    """
    Sends the prompt to OpenAI's API and returns the response text as a string.
    """
    client = openai.OpenAI(api_key=openai_key)
    response = client.chat.completions.create(
        model=MODEL_NAME,
        messages=[{"role": "system", "content": prompt["system"], },
                  {"role": "user", "content": prompt["user"], }, ])
    return (response.model_dump(exclude_unset=True).get("choices", [{}])[0].get("message", {}).
            get("content"))


def send_ses_email(subject: str, body: str) -> None:
    """
    Sends an email using Amazon Simple Email Service (SES).
    """
    email_address = get_ssm_parameter_by_key(EMAIL_ADDRESS_PATH)
    ses = boto3.client("ses")
    ses.send_email(
        Source=email_address,
        Destination={"ToAddresses": [email_address], },
        Message={"Subject": {"Data": subject, },
                 "Body": {"Text": {"Data": body, }, }, })


def handler(event: dict, context: dict) -> str:
    """
    This function is the entry point for the Lambda function.
    """
    logger.info("Starting the story-teller Lambda function")
    openai_api_key = get_ssm_parameter_by_key(API_KEY_PATH)
    item_from_table = get_prompt_from_dynamo_table(get_ssm_parameter_by_key(PROMPT_KEY_PATH))

    logger.info(f"Sending prompt to OpenAI")
    response_from_openai = send_prompt_to_openai(openai_api_key, item_from_table)

    logger.info(f"Sending email with the response from OpenAI")
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    email_subject = f"Story teller email for {current_date}"
    send_ses_email(email_subject, response_from_openai)

    logger.info("Story-teller Lambda function completed")
