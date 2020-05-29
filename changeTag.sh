#!/bin/bash
sed "s/tagVersion/$1/g" podsbaseconfig > pods.yml
