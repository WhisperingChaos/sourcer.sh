#!/bin/bash

# a lesser implementation to aggregate components as the component aggregater
# boots itself.  the below loads the base and permits overriding its contents
# without touching the base implementation (Open/Close) principle of SOLID
source "$(dirname "${BASH_SOURCE[0]}")"/base/includes.include.sh 
