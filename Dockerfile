FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY FoodHelp.sln .
COPY FoodHelp/*.csproj ./FoodHelp/
RUN dotnet restore

# copy everything else and build app
COPY FoodHelp/. ./FoodHelp/
WORKDIR /app/FoodHelp
RUN dotnet publish -c release -o out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/FoodHelp/out ./
ENTRYPOINT ["dotnet", "FoodHelp.dll"]