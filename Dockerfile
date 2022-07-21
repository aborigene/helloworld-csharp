FROM mcr.microsoft.com/dotnet/sdk:6.0 as BUILD

COPY "." "/src"
WORKDIR /src
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:6.0

RUN apt-get update
RUN apt-get install curl -y

COPY --from=BUILD "/app" "/app"
COPY "entrypoint.sh" "/app/entrypoint.sh"
COPY "shim.sh" "/app/shim.sh"

RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/shim.sh

#COPY "installer.sh" "/"
#RUN sh /installer.sh /opt/
#RUN apt-get update
#RUN apt-get install -y unzip 
#RUN unzip -d /opt/dynatrace /oneagent.zip
#RUN rm -rf /opt/dynatrace/log
#RUN ln -s /var/log/ /opt/dynatrace/log/dotnet

#ENV LD_PRELOAD="/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so"

#ENTRYPOINT echo 'test' && ls
#ENV DT_ENDPOINT=https://dynatrace.carrefoursolucoes.com.br:9999/e/f8cdddaf-c019-4deb-8553-c1549cbdfce0
#ENV 
ENTRYPOINT [ "/bin/bash", "/app/shim.sh" ]
#ENTRYPOINT LD_PRELOAD="/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so" && dotnet /app/helloworld-csharp.dll


#FROM mcr.microsoft.com/dotnet/aspnet:6.0
#COPY --from=BUILD "/app" "/app"

#ENTRYPOINT dotnet /app/helloworld-csharp.dll