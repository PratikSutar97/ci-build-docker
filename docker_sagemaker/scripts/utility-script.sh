#!/bin/bash
set -e
SDLC_ENVIRONMENT=$1
git_folder_arg=$2
echo "start of utility-script.sh"
if [[ ( -z "$SDLC_ENVIRONMENT" ) || ( -z "$git_folder_arg" ) ]]; then
    echo "Exiting: Build Parameters Missing"
    exit 1
fi
echo "git_folder_arg is: $git_folder_arg"
git_folder_name=$CODEBUILD_SRC_DIR/$git_folder_arg
echo "git_folder_name is: $git_folder_name"

cd $git_folder_name

src_dir=$CODEBUILD_SRC_DIR

commit_id=$CODEBUILD_RESOLVED_SOURCE_VERSION
echo "below output is of git command"
git show --no-notes --notes=* --pretty=format:"%N"  --name-only $commit_id | awk -F"/" '{print $1}' | uniq
echo "above output is of git command"
for dir_name in $(git show --no-notes --notes=* --pretty=format:"%N"  --name-only $commit_id | awk -F"/" '{print $1}' | uniq)
do
    echo "Inside For Loop dir_name :  $dir_name"
    if [[ "$dir_name" =~ ^model.* ]]; then
        filename=$src_dir/$dir_name/container/build_and_push.sh
        if [ ! -f "$filename" ]
        then
            echo "$0: File '${filename}' not found."
        else
            echo "File Exists"
            bash $filename $SDLC_ENVIRONMENT $dir_name
        fi
    fi
done

echo `date +%Y-%M-%d-%H-%M-%S`
echo `pwd`
echo `$PATH`

echo "end of utility-script.sh"