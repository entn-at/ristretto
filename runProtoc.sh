#!/bin/sh
# I can't get the cmake custom command to work so this is just a workaround
cd build
mkdir -p src
protoc --grpc_out ./src --cpp_out ./src -I ../src/protos \
 --plugin=protoc-gen-grpc=$(which grpc_cpp_plugin) ../src/protos/ristretto.proto
