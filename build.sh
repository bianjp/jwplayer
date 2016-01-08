#!/usr/bin/bash

# The version to build, like "7.2.4"
version=$1
temp_dir=tmp

if [ -z "$version" ]; then
  echo "No version provided"
else
  rm -rf $temp_dir
  mkdir $temp_dir
  curl --fail -o $temp_dir/jwplayer.zip "https://ssl.p.jwpcdn.com/player/download/jwplayer-${version}.zip"
  if [ "$?" != "0" ]; then
    echo "Failed to download jwplayer"
  else
    unzip -d $temp_dir $temp_dir/jwplayer.zip
    if [ "$?" != "0" ]; then
      echo "Failed to extract files"
    else
      rm -rf dist
      mv $temp_dir/jwplayer-* dist

      # update version number
      sed -i "s#\"version\":[ ]*\".*\"#\"version\": \"$version\"#" bower.json
      sed -i "s#\"version\":[ ]*\".*\"#\"version\": \"$version\"#" package.json

      # publish to npmjs.org
      npm publish --access=public
    fi
  fi
fi
