#!/bin/bash

# 运行pnpm build，只在有错误时输出

output=$(pnpm build 2>&1)
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "✅ 编译成功"
else
    echo "❌ 编译失败"
    # 过滤掉空行和>开头的非报错部分
    echo "$output" | grep -v '^\s*$' | grep -v '^>' | grep -v '^\s*>'
    exit $exit_code
fi
