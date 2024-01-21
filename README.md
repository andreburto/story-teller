# Story Teller

## About

A simple, scheduled task that emails me a short block of fiction everyday.
A test bed to get familiar with working with the [OpenAI API](https://openai.com/blog/openai-api) and other platforms.

## Setup

TBD

## To Do

* Update Terraform configuration with other needed resourses.
* Create the Python code that:
  * works with the ChatGPT API;
  * sends email through SES;
  * stores output in S3;
  * reads sensitive data from SSM.
* Add tests that use [moto](https://docs.getmoto.org/en/latest/docs/services/lambda.html) to confirm the Lambda works.

## Changes

*2024-01-20:* Initial work begun. Created the Terraform configuration for the basic Lambda funtion that runs on a schedule.
