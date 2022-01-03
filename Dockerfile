#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["TSYCore.csproj", ""]
RUN dotnet restore "./TSYCore.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "TSYCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TSYCore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TSYCore.dll"]