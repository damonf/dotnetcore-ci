# Docker file for multi-stage build

FROM microsoft/dotnet:2.0-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.0-sdk as build
WORKDIR /src
COPY . .
RUN dotnet restore; dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app/publish
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnetcore-ci.dll"]

# FROM microsoft/dotnet:2.0-sdk
# WORKDIR /src
# COPY . .
# RUN dotnet restore; dotnet build
# CMD ["dotnet", "run"]