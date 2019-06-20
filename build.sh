#!/bin/sh

COMPILER=nvcc
FLAGS="-arch=sm_61"
INCLUDE=""
LIBS=""

$COMPILER $FLAGS $INCLUDE $LIBS ./main.cu -o ./build/a.out