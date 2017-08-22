#!/bin/bash
# -*- coding: utf-8 -*-
#
# This file is part of sbpipe.
#
# sbpipe is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# sbpipe is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with sbpipe.  If not, see <http://www.gnu.org/licenses/>.
#
#
#
# $Revision: 1.0 $
# $Author: Piero Dalle Pezze $
# $Date: 2017-08-22 09:22:32 $



# This script releases a new version of SBpipe or update the last github tag.
# This script also creates and uploads a new SBpipe package for anaconda cloud.
#
# Type `release.sh -h` for help.



# This can be `new` or `update`
action=${1}

# This is a string representing the new version (e.g. v4.0.0)
version=${2-null}


if [ "${action}" == "-n" -o "$action" == "--new" ] && [ "$version" != "null" ]
then
    printf "create a new tag\n"

    # We always action from the `master` branch
    printf "checkout master\n"
    git checkout master

    # add a tag
    git tag -a ${version} -m "sbpipe ${version}"
    # transfer the tag to the remote server
    # this goes in a separate 'branch'
    git push origin ${version}


elif [ "${action}" == "-u" -o "$action" == "--update" ] && [ "$version" != "null" ]
then
    printf "update and rename the last tag with current commits\n"

    # We always action from the `master` branch
    printf "checkout master\n"
    git checkout master

    # rename and update the last tag so that it contains the last commit
    # retrieve the last tag
    last_tag=$(git describe --abbrev=0 --tags)
    printf "current tag: ${last_tag}\n"

    # Update the last tag to include the last commits
    git tag -f -a ${last_tag}
    # push this updated tag
    #git push -f --tags

    # rename a tag
    git tag ${version} ${last_tag}
    git tag -d ${last_tag}
    git push --tags
    # make sure that the other users remove the deleted tag. Tell them(co-workers) to run the following command:
    git pull --prune --tags
    printf "every user with permission to release, should run `git pull --prune --tags`\n"


elif [ "${action}" == "-h" -o "${action}" == "--help" ]
then
    printf "\nNAME\n"
    printf "\trelease.sh - A tool for releasing new/updated SBpipe versions"
    printf "\n\nSYNOPSIS\n"
    printf "\trelease.sh [-h] [-n version] [-u version]"
    printf "\n\nDESCRIPTION\n"
    printf "\tThis tool releases a new SBpipe version or update the current tag on github and anaconda cloud.\n"
    printf "\tThe option are as follows:\n"
    printf "\t-n, --new version\t create a new tag called version\n"
    printf "\t-u, --update version\t update the last tag with the current commits and renamed it to version\n"
    printf "\t-h, --help\t\t shows this help\n"
    printf "\n"
    exit 0

else
    echo "ERROR. See: release.sh --help for command syntax\n"
    exit 1
fi



printf "release a new SBpipe package for anaconda cloud\n"
# we upload this new package automatically
conda config --set anaconda_upload yes
# build and upload the package
conda build conda_recipe/meta.yaml -c conda-forge

## To test this package locally:
## install
# conda install sbpipe --use-local
## uninstall
# conda remove sbpipe
