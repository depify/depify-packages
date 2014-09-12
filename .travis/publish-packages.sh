#!/bin/bash

set | grep TRAVIS

    echo -e "Setting up for publication...\n"
    
    echo -e "Setting up for publishing depify packages.xml ...\n"

    cp -R dist $HOME/packages

    cd $HOME
    git config --global user.email "jim.fuller@webcomposite.com"
    git config --global user.name "depify"
    git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/depify/depify-website gh-pages > /dev/null

    if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
        echo -e "Publishing depify packages.xml...\n"

        TIP=${TRAVIS_TAG:="head"}

        cd gh-pages
        git rm -rf ./packages/${TRAVIS_BRANCH}/${TIP}
        mkdir -p ./packages/${TRAVIS_BRANCH}/${TIP}
        cp -Rf $HOME/packages/* ./packages/${TRAVIS_BRANCH}/${TIP}

        git add -f .
        git commit -m "Successful travis build $TRAVIS_BUILD_NUMBER"
        git push -fq origin gh-pages > /dev/null

        echo -e "Published depify packages.xml to gh-pages.\n"
    else
        echo -e "Publication cannot be performed on pull requests.\n"
    fi

