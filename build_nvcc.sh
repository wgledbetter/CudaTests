#!/bin/sh

COMPILER=nvcc
FLAGS="-arch=sm_61"
GCC_OPTS="--compiler-options -O3,-Wall"
INCLUDE=""
LIBS=""

$COMPILER $GCC_OPTS $FLAGS $INCLUDE $LIBS ./main.cu -o ./build/a.out