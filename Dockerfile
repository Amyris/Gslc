FROM fsharp:10.10.0

WORKDIR /gsl
COPY . /gsl

ENV GSL_LIBRARY_VERSION=1.0.1
ENV VisualStudioVersion=14.0

RUN /bin/bash -c "./build.sh build"
