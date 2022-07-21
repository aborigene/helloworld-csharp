#!/bin/bash
#apt-get update
#apt-get install curl -y
curl -o /tmp/installer.sh -s "$DT_ENDPOINT/api/v1/deployment/installer/agent/unix/paas-sh/latest?Api-Token=$DT_TOKEN&arch=x86&include=dotnet"

sh /tmp/installer.sh

export LD_PRELOAD="/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so"

env

dotnet /app/helloworld-csharp.dll