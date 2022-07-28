# Details on this lab

This is a simple app just to demonstrate how to put OneAgent and Google CloudRun together. This is a simple hellow-world c# application that has two URLs: 

1. /
2. /outraURL

# How to bring the app up on Google CloudRun

1. Inside the repo root folder run a Google Build: ```gcloud builds submit --tag gcr.io/<project>/<your_image_name>```
2. Inside your Google Console, go to CloudRun and create a new service
3. Fill all the required information:
4. Add the image you built before
5. Env var DT_ENDPOINT, pointing to your Dynatrace endpoint this should be something like ```https://ag_ip:9999/e/<env_id>``` or ```https://xxxxxx.live.dynatrace.com```
6. Env var DT_TOKEN, this should be a valid PaaS token for download and installation
7. Send request to your services. Unless specified otherwise on service creation, the request will require authentication, send the requested with authentication headers like this: ```curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" <service_url>/``` or ```curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" <service_url>/outraURL```

Only after the request is sent the agent will actually start.

This repo using the shim.sh script that triggers two other scripts just to make sure we can send the OA logs to the Google Logs, on an actual deploy to production this won't be needed.

