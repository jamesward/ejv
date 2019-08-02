#!/bin/bash

BASEDIR=$(dirname $0)
cd $BASEDIR

if [ "$1" == "" ]; then
    printf "You must specify the ejv command to use from within a test dir. e.g. ../../ejv\n"
    exit 1
else
    readonly EJV=$1
fi

# Runs a test
#
# Usage:
#
#  run_test base_dir expected_output
#
run_test() {
  local DIR=$1
  local EXPECTED=$2

  unset JAVA_HOME
  # todo: remove java from the path
  
  printf "Running $EJV in $DIR\n"

  cd $DIR

  source $EJV
  echo $JAVA_HOME

  if [ "$JAVA_HOME" != "" ]; then
    local OUTPUT="$($JAVA_HOME/bin/java -version 2>&1)"
  else
    local OUTPUT="JAVA_HOME did not get set"
  fi

  cd ..

  printf "Output:\n$OUTPUT\n\n"
  printf "Expected:\n$EXPECTED\n\n"

  if [ "${OUTPUT#*$EXPECTED}" != "$OUTPUT" ]; then
    printf "Test passed!\n\n"
  else
    printf "Test failed!\n"
    exit 1
  fi
}


# No system.properties
run_test "no_file" "JAVA_HOME did not get set"

# No java.runtime.version in the system.properties
run_test "no_version" "JAVA_HOME did not get set"

# Use AdoptOpenJDK by default
run_test "nodistro-1.8" "OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_222-b10)"

# Use AdoptOpenJDK by default
run_test "nodistro-1.8.0" "OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_222-b10)"

# Use AdoptOpenJDK by default
run_test "nodistro-1.8.0_212" "OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_212-b10)"
