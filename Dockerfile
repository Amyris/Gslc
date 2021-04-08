FROM mcr.microsoft.com/dotnet/sdk:5.0

WORKDIR /gsl
COPY . /gsl

RUN /bin/bash -c "dotnet build src/Gslc -o bin/Gslc"

#ENTRYPOINT ["./bin/Gslc/Gslc"]
