#!/bin/bash

dbt_cmd=$1

echo "Running dbt command"
dbt deps && $dbt_cmd

# rethrowing the exit code to KubernetesPodOperator
exit_code=$?
exit $exit_code