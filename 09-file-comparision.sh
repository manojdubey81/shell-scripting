#!/bin/bash

if [ ! -f components/$1.sh ]; then
	echo “component does not exist”
	exit 1
fi

bash component/$1.sh
