# Story Teller

## About

A simple, scheduled task that emails me a short block of fiction everyday.
A test bed to get familiar with working with the [OpenAI API](https://openai.com/blog/openai-api) and other platforms.

## Setup

TBD

## To Do

* Tighten up IAM policies, removing excess permissions.
* Modify the Python code to:
  * Store output in S3.
  * Send email with HTML formatting.
  * Reduce number of AWS clients created.
* Add tests that use [moto](https://docs.getmoto.org/en/latest/docs/services/lambda.html) to confirm the Lambda works.
* Automate deploying Terraform.

## Changes

*2024-02-18:* Cleaned up `build.sh`.
Updated the scheduler to just send an email once a day.

*2024-02-18:* Created primitive build script to package the Lambda function and its dependencies.
Still requires manual steps to deploy, but that will be fixed.
Updated Python script to work as MVP.

*2024-02-17:* Making some additional changes to the Terraform configuration.

*2024-01-20:* Initial work begun. Created the Terraform configuration for the basic Lambda funtion that runs on a schedule.
