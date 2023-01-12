#!/bin/bash
while [ true ]
do
  curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" https://minhamensagem-csharp-ujz24sgwbq-ue.a.run.app/outraURL 
  curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" https://minha-mensagem-csharp-local-ujz24sgwbq-uc.a.run.app/ 
done
