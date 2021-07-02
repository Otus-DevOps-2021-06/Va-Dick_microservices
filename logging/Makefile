#!/bin/bash

docker_hub_repo_name='vadimrepo'

function help_fun {
  echo "----------------------------------------ERROR!----------------------------------------"
  echo "The command to run should look like this: Makefile -i image_name -p true|false"
  exit 0
}


ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
array_of_files=($(ls $ABSDIR))
array_of_dir=()

for file in "${array_of_files[@]}"
do
  if [[ -d $ABSDIR"/"$file ]];  then
    array_of_dir+=($file)
  fi
done

image=""
push=""

while getopts 'i:p:' flag
do
    case "${flag}" in
        i) image=${OPTARG};;
        p) case ${OPTARG} in
           "true"|"false") push=${OPTARG};;
           *) help_fun
           esac
           ;;
        *) help_fun
    esac
done

if [[ -z "$image" ]]
then
  help_fun
fi

if [[ ! " ${array_of_dir[@]} " =~ " ${image} " ]]; then
    echo "Incorrect image name: "$image
    echo "Perhaps you meant: "${array_of_dir[@]}
    help_fun
fi


echo "----------------------------------------Build image name: "$image"----------------------------------------"
cd $ABSDIR/$image
docker build -t $docker_hub_repo_name"/"$image ./
cd -


if [ "$push" == "true" ]; then
    echo "--------------------------------Image push in docker hub registry: "$docker_hub_repo_name"------------------------------------"
    docker push $USER_NAME"/"$image
fi
