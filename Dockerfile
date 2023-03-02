FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./

# Restore as distinct layers
RUN dotnet restore ./App/DotNet.Docker.csproj --no-cache --configfile "NuGet.Config"

# Build and publish a release
RUN dotnet publish ./App/DotNet.Docker.csproj -c Release --no-restore -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /App

COPY --from=build-env /App/out .

ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]