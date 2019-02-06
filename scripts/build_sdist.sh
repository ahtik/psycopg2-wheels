#!/bin/bash

set -e -x

cd $TRAVIS_BUILD_DIR/psycopg2

# Find psycopg version
export VERSION=$(grep -e ^PSYCOPG_VERSION setup.py | sed "s/.*'\(.*\)'/\1/")
# A gratuitous comment to fix broken vim syntax file: '")

# Replace the package name
if [[ "${PACKAGE_NAME:-}" ]]; then
    sed -i "s/^setup(name=\"psycopg2\"/setup(name=\"${PACKAGE_NAME}\"/" \
        setup.py
fi

# Build the source package
python setup.py sdist -d "dist/psycopg2-$VERSION"

# install and test
sudo pip install "dist/psycopg2-$VERSION"/*

export PSYCOPG2_TESTDB_USER=postgres
export PSYCOPG2_TEST_FAST=1
python -c "import tests; tests.unittest.main(defaultTest='tests.test_suite')"
