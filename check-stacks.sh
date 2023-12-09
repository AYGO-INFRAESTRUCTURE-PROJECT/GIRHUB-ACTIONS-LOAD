#!/bin/bash

# Ruta de la carpeta con los stacks
stacks_folder="./stacks"

if [ -d "$stacks_folder" ]; then

    stacks=$(find "$stacks_folder" -maxdepth 1 -type d | sed '1d' )

    for stack in $stacks; do
        stack_name=$(basename "$stack")
        stack_file_name="$stack/$stack_name.json"
        if [ -e "$stack_file_name" ]; then
            echo "$stack_file_name"
            result=$(sam validate --template-file "$stack_file_name" --lint)
            echo "$result"
            if [[ $result == *"valid SAM Template"* ]]; then
                echo "-------------stack $stack_name is valid to deploy.-------------"
                sam deploy --template-file $stack_file_name --stack-name $stack_name --capabilities CAPABILITY_IAM
            fi
        else
            echo "El archivo $stack_file_name no existe."
        fi
        echo "---------------------------------"
    done
else
    echo "La carpeta $carpeta_stack no existe."
fi
