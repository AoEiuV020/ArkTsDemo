---
name: git-export
description: 导出携带submodule的源码包。需要打包项目源码、交付代码包时使用。
---

# Git 源码包导出

使用 `git-archive-all` 导出携带 submodule 的完整源码包。

## 前置依赖

```bash
pip install git-archive-all
```

## Submodule 更新

导出前确保 submodule 已拉取且为最新：

```bash
# 首次拉取
git submodule update --init --recursive
# 更新到远程最新
git submodule update --remote --recursive
```

## 使用方式

```bash
# 默认：当前项目，zip格式，输出到 ln/output
node <skill-dir>/scripts/export.js

# 指定项目路径
node <skill-dir>/scripts/export.js --project /path/to/repo

# 指定输出目录和格式
node <skill-dir>/scripts/export.js --output /path/to/output --format tar.gz
```

## 输出

- 格式：zip
- 路径：`ln/output/{项目名}_{commitHash}_{日期}.zip`
- 示例：`example_a1b2c3d_20260211.zip`
