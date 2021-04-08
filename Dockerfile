FROM mcr.microsoft.com/dotnet/sdk:5.0

WORKDIR /gsl
COPY . /gsl

RUN /bin/bash -c "./build.sh build"

ENTRYPOINT ["./bin/Gslc/Gslc"]
