#!/bin/bash
# 修复的构建脚本

cd ~/Documents/stm32/project

echo "=== STM32 构建 ==="

case "${1:-all}" in
    "clean")
        echo "清理..."
        make clean
        ;;
    "build")
        echo "编译..."
        make
        ;;
    "flash")
        echo "下载..."
        make flash
        ;;
    "all")
        echo "完整流程..."
        make clean
        make
        make flash
        ;;
    *)
        echo "用法: $0 [clean|build|flash|all]"
        exit 1
        ;;
esac

echo "=== 完成 ==="