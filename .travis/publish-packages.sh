#!/bin/bash

set | grep TRAVIS
set | grep GIT_
set | grep GH_

    echo -e "Setting up for publication...\n"

    cp -R dist/packages.xml  $HOME/packages.xml

    cd $HOME
    git config --global user.email ${GIT_EMAIL}
    git config --global user.name ${GIT_NAME}
    git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/depify/depify-websites gh-pages > /dev/null

    if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
        echo -e "Publishing specification...\n"

        TIP=${TRAVIS_TAG:="head"}

        cd gh-pages
        git rm -rf ./packages/${TRAVIS_BRANCH}/${TIP}
        mkdir -p ./packages/${TRAVIS_BRANCH}/${TIP}
        cp -Rf $HOME/packages/* ./packages/${TRAVIS_BRANCH}/${TIP}

        git add -f .
        git commit -m "Successful travis build $TRAVIS_BUILD_NUMBER"
        git push -fq origin gh-pages > /dev/null

        echo -e "Published specification to gh-pages.\n"
    else
        echo -e "Publication cannot be performed on pull requests.\n"
    fi

