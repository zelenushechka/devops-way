from fastapi import FastAPI
import os
import requests

app = FastAPI()

AUX_SERVICE_URL = os.getenv("AUX_SERVICE_URL", "http://localhost:8001")

MAIN_API_VERSION = "1.0.0"

@app.get("/s3-buckets")
def list_s3_buckets():
    response = requests.get(f"{AUX_SERVICE_URL}/s3-buckets").json()
    return {
        "buckets": response["buckets"],
        "main_version": MAIN_API_VERSION,
        "aux_version": response["version"]
    }

@app.get("/parameters")
def list_parameters():
    response = requests.get(f"{AUX_SERVICE_URL}/parameters").json()
    return {
        "parameters": response["parameters"],
        "main_version": MAIN_API_VERSION,
        "aux_version": response["version"]
    }

@app.get("/parameter/{param_name:path}")
def get_parameter(param_name: str):
    response = requests.get(f"{AUX_SERVICE_URL}/parameter/{param_name}").json()
    return {
        "parameter": response["parameter"],
        "main_version": MAIN_API_VERSION,
        "aux_version": response["version"]
    }
