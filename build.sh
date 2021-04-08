#!/usr/bin/env bash
# Optional environment variables.  You may want to set the APP_* vars
# if using gsl_start or gsl_dev when developing outside of docker:
# DOTNET_EXECUTABLE=[path to your executable in non standard location]
# APP_PORT=[some port]  # defaults to 8000
# APP_INI_FILE=[path to ini file]  # defaults to ./ini/development.ini
# APP_LOG_DIR=[path to log file]  # defaults to /var/log/amyris/gsl
# update TARGET_FRAMEWORK if you upgrade the GslServer target Framework in
# the GslProject.fsproj so gsl_dev will be able to find the executable.
TARGET_FRAMEWORK=${TARGET_FRAMEWORK:-net5.0}

set -eu

cd "$(dirname "$0")"

# set the dotnet executable we'll use (may be in different locations on different platforms)
dotnet_executable=${DOTNET_EXECUTABLE:-}
windows_wsl2_bash_dotnet_location="/mnt/c/Program Files/dotnet/dotnet.exe"
# may need to add support for other locations of dotnet here (not sure about osx)
if [[ -x "$(command -v dotnet)" ]]
then
    dotnet_executable='dotnet'
elif [ -x "$windows_wsl2_bash_dotnet_location" ]
then
    dotnet_executable="$windows_wsl2_bash_dotnet_location"
fi

set +e

# run a dotnet command using the executable matched above
dotnet_command () {
    if [[ -z "$dotnet_executable" ]]
    then
        "Can't find dotnet dotnet executable."
        exit 1;
    fi
    echo $dotnet_executable "$@"
    "${dotnet_executable}" "$@"
}

yesno () {
    # NOTE: Defaults to NO
    read -p "$1 [y/N] " ynresult
    case "$ynresult" in
        [yY]*) true ;;
        *) false ;;
    esac
}

# default is to build everything with project defaults and output to
# [project_file_folder]/bin/[configuration]/[framework]/publish/
# probably never use this, maybe goes away?
build_all () {
    dotnet_command build $@
}

# build the necessary components for a docker deployment
build () {
    publish_bin Gslc
}

# first argument should be a path to an fsproj or a project name is src
# (assuming the directory name in source and the name of the fsproj are the same)
# so
# build.sh build_deploy src/GslServer/GslServer.fsproj
# or
# build.sh build_deploy GslServer
# should both work.
# any remaining arguments will be passed as additional arguments to build
# will build to the bin/project_name directory
publish_bin () {
    project_path=$1
    project_file=$(basename $project_path)
    project_name=${project_file%.fsproj}
    if [[ $project_path == $project_name ]]
    then
       project_path="src/$project_name/$project_name.fsproj"
    fi
    shift
    dotnet_command publish $project_path -o bin/$project_name $@
}

# convenience method to run a project in bin/[project] (as produced by build_deploy)
# arg can be just the name (no .dll) for projects published to the bin directory,
# otherwise should be a full path to the executable.
# E.g. build.sh run GslServer 8080 ini/development.ini /tmp/logs
run () {
    executable=$1
    shift
    if [[ ! "$executable" == *".dll" ]]
    then
        executable="bin/$executable/$executable.dll"
    fi
    dotnet_command "$executable" $@
}

run_regression_tests () {
    dotnet_command fsi regression_tests/runtests.fsx $@
}

# a convenience method for calling diff to check failed regression test output.
rdiff () {
    diff --strip-trailing-cr regression_tests/$1.out regression_test_results/$1.out
}

# convenience when this script is used as an entrypoint to docker
bash () {
  /bin/bash
}

# get the command name
cmd=${1}
shift
# run the command, passing forward any remaining arguments
${cmd} $@
