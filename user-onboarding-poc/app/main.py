from flask import Flask, request, jsonify
import requests
import os
import json

app = Flask(__name__)

ARGO_WORKFLOW_URL = os.environ.get("ARGO_WORKFLOW_URL")  # e.g., https://argo-server.argo.svc.cluster.local:2746/api/v1/workflows/argo/submit
ARGO_TOKEN = os.environ.get("ARGO_TOKEN")  # Service Account token or Bearer token

HEADERS = {
    "Authorization": f"Bearer {ARGO_TOKEN}",
    "Content-Type": "application/json"
}


@app.route("/", methods=["POST"])
def handle_pubsub():
    envelope = request.get_json()
    if not envelope or "message" not in envelope:
        return "Bad Request: Missing Pub/Sub message", 400

    pubsub_message = envelope["message"]

    try:
        payload = json.loads(base64_decode(pubsub_message["data"]))
        user_email = payload.get("email", "unknown@domain.com")
        print(f"New user added: {user_email}")

        workflow = {
            "workflow": {
                "metadata": {"generateName": "user-onboard-"},
                "spec": {
                    "entrypoint": "onboard-user",
                    "templates": [{
                        "name": "onboard-user",
                        "container": {
                            "image"
