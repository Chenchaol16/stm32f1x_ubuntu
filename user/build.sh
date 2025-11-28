#!/bin/bash
# 修复的构建脚本

cd ..

echo "start"

case "${1:-all}" in
    "clean")
        echo "clean..."
        make clean
        ;;
    "build")
        echo "build..."
        make
        ;;
    "flash")
        echo "flash..."
        make flash
        ;;
    "all")
        echo "all..."
        make clean
        make
        make flash
        ;;
    *)
        echo "use: $0 [clean|build|flash|all]"
        exit 1
        ;;
esac

echo "done"