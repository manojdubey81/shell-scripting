#!/bin/bash

if [ ! -e roboshop/components/$1.sh ]; then
	echo “component $1 does not exist”
	exit 1
else
  echo “component $1 exist”
fi

#bash component/$1.sh
