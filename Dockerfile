FROM microsoft/dotnet:2.0-sdk AS build-env
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet publish -c Release -r linux-x64 -o out
#RUN dotnet publish -c Release -o out

FROM microsoft/dotnet:2.0-runtime-deps
WORKDIR /app
COPY --from=build-env /app/out ./
#COPY /app/out ./
COPY ./config.json /app/out
COPY ./index.html /app/out
#ENTRYPOINT  ["/app/DNWS"]

ENTRYPOINT dotnet build 
#if use RUN -> "dotnet not found" error
ENTRYPOINT [ "dotnet", "run" ]
#at this point, a container with CREATED status and PORT 0.0.0.:8080 -> 8080 appears.
#but cannot access via http://localhost:8080 or docker-machine ip
#CMD dotnet build
#CMD dotnet run