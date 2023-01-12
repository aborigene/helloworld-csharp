FROM mcr.microsoft.com/dotnet/sdk:6.0 as BUILD

COPY "." "/src"
WORKDIR /src
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:6.0

# this is just to make download of the installer possible
RUN apt-get update
RUN apt-get install curl -y

COPY --from=BUILD "/app" "/app"
COPY "entrypoint.sh" "/app/entrypoint.sh"
COPY "shim.sh" "/app/shim.sh"

RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/shim.sh

ENV DT_ENDPOINT=https://XXX
ENV DT_TOKEN=xxxx

ENTRYPOINT [ "/bin/bash", "/app/entrypoint.sh" ]
#ENTRYPOINT LD_PRELOAD="/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so" && dotnet /app/minhamensagem-csharp.dll


#FROM mcr.microsoft.com/dotnet/aspnet:6.0
#COPY --from=BUILD "/app" "/app"

#ENTRYPOINT dotnet /app/minhamensagem-csharp.dll