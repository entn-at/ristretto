#!/bin/sh
set -e

run_build()
{
    echo "Running clientEntry.sh::run_build()"
    if [ "$SKIP_PROTOC" != "YES" ]; then
        ./runProtoc.sh
    fi
    cd /opt/ristretto/build
    cmake .. -DBUILD_SERVER=OFF -DBUILD_CLIENT=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja
    cmake --build . --parallel $(nproc)
    cd -
}

run_tests()
{
    echo "Running clientEntry.sh::run_tests()"
    # Could use ctest binary, but the executable itself is more verbose on CLI
    #ctest . -E "USER_INPUT|REQUIRES_SERVER"

    # Test resources are copied into bin
    pushd /opt/ristretto/build/bin
    TEST_BINARY="./ClientTest"
    GTEST_ARGS=" --gtest_filter=-*USER_INPUT*:*REQUIRES_SERVER* "
    test -f $TEST_BINARY || { echo "$TEST_BINARY does not exist, have you built it yet?"; exit 1; }
    CMD="$TEST_BINARY $GTEST_ARGS"
    eval $CMD
    popd
}

start_client()
{
    echo "Running clientEntry.sh::start_client()"
    cd /opt/ristretto
    ./build/bin/RistrettoClient
    cd -
}

main()
{
    cd /opt/ristretto
    if [ "$SKIP_BUILD" != "YES" ]; then
        run_build
    fi
    if [ "$SKIP_TESTS" != "YES" ]; then
        run_tests
    fi
    if [ "$SKIP_RUN" != "YES" ]; then
        start_client
    fi
}

main