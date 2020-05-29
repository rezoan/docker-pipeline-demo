#!/bin/bash
sed "s/repoName/$1/g;s/tagVersion/$2/g" podsbaseconfig > pods.yml
