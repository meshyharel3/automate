#!/bin/bash

# create ip list in one file
DIR="."


OUTPUT_FILE="host_ip_list.txt"


if [ ! -f "$OUTPUT_FILE" ]; then
  touch "$OUTPUT_FILE"
  echo "File $OUTPUT_FILE created in $(pwd)"
else
  echo "File $OUTPUT_FILE already exists in $(pwd)"
fi


terraform apply "Ansible_with_Terraform.tf"
