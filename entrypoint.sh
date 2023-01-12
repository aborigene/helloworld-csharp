#!/bin/bash

echo "Downloading OneAgent"
curl -ko /tmp/installer.sh -s "$DT_ENDPOINT/api/v1/deployment/installer/agent/unix/paas-sh/latest?Api-Token=$DT_TOKEN&arch=x86&include=dotnet" 

#cat /tmp/installer.sh

echo "Installing OneAgent"
sh /tmp/installer.sh

export LD_PRELOAD="/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so"

echo "Starting Main App"
dotnet /app/minhamensagem-csharp.dll
