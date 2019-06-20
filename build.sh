#!/bin/sh

COMPILER=nvcc
FLAGS=""
INCLUDE=""
LIBS=""

$COMPILER $FLAGS $INCLUDE $LIBS ./main.cu -o ./build/a.out