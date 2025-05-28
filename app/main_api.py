#placeholder
from fastapi import FastAPI
import boto3
import os

app = FastAPI()

# AWS Client
s3_client = boto3.client("s3")
ssm_client = boto3.client("ssm")

# API version
AUX_SERVICE_VERSION = "1.0.0"

@app.get("/s3-buckets")
def list_s3_buckets():
    buckets = s3_client.list_buckets()["Buckets"]
    bucket_names = [bucket["Name"] for bucket in buckets]
    return {"buckets": bucket_names, "version": AUX_SERVICE_VERSION}

@app.get("/parameters")
def list_parameters():
    parameters = ssm_client.describe_parameters()["Parameters"]
    param_names = [param["Name"] for param in parameters]
    return {"parameters": param_names, "version": AUX_SERVICE_VERSION}

@app.get("/parameters/{param_name}")
def get_parameter(param_name: str):
    response = ssm_client.get_parameter(Name=param_name)
    return {"parameter": response["Parameter"]["Value"], "version": AUX_SERVICE_VERSION}
