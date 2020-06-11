#!/bin/bash

setup_git() {
  git config --global user.email "allegro-soap@travis.example.com"
  git config --global user.name "Travis CI"
}

commit_changes() {
  git add allegro-soap.xml allegro-soap.orig.xml VERSION
  git commit --message "New WSDL version: $VERSION"
}

upload_files() {
  git remote add my-origin https://${GH_TOKEN}@github.com/mattesilver/allegro-soap.git > /dev/null 2>&1
  git push --set-upstream my-origin $TRAVIS_BRANCH
}

setup_git
commit_changes
upload_files
