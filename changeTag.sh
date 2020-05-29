#!/bin/bash
sed "s/tagVersion/$1/g" podsconfig > pods.yml
