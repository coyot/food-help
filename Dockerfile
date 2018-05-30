FROM microsoft/dotnet:2.1-sdk AS build

#install Node.js
RUN apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_4.x | sudo bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential

WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
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