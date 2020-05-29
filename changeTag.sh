#!/bin/bash
sed "s/serviceName/$1/g;s/tagVersion/$2/g" podsbaseconfig > pods.yml
