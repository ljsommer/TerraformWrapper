#! /bin/bash

terraform_version="0.11.3"

echo "Building Docker image: terramorph with Terraform version: $terraform_version"
#docker build -t $image_name --build-arg terraform_version=$terraform_version ./docker

function terramorph () {
    if [[ -z "${TERRAFORM_ENV}" ]]; then
        echo "TERRAFORM_ENV environment variable not set. Please set and re-run."
        return 1
    else
        printf "Terraform environment recognized as ${TERRAFORM_ENV}\n\n"
    fi

    docker run -i -t --rm \
        --name terramorph \
        -e "TERRAFORM_ENV=$TERRAFORM_ENV" \
        -v ${HOME}/.aws/:/root/.aws/ \
        -v ${HOME}/.ssh/:/root/.ssh/ \
        -v $(pwd):/opt/terramorph/code/ \
        terramorph "$1"
}

alias tm=terramorph

if [[ ! -s "$HOME/.bash_profile" && -s "$HOME/.profile" ]] ; then
  profile_file="$HOME/.profile"
else
  profile_file="$HOME/.bash_profile"
fi

if ! grep -q 'terramorph' "${profile_file}" ; then
  echo "Editing ${profile_file} to configure Terramorph function on terminal launch"
  echo "function $(declare -f terramorph)"  >> "${profile_file}"
  echo "alias tp=terramorph" >> "${profile_file}"
fi