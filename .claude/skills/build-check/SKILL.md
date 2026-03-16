---
name: build-check
description: 编译检查与缓存清理。修改.ts/.ets代码后、需要清理构建缓存时，必须调用此skill。
---

# 编译检查

## 环境准备

首次使用或依赖变更后需初始化：

```bash
git submodule update --init --recursive
ohpm i
```

## 执行编译

```bash
node <skill-dir>/scripts/build.js [mode]
```

**mode参数说明：**

- `ts` - 仅编译TypeScript代码
- `ets` - 仅编译ETS代码
- `all` - 同时编译TypeScript和ETS（默认）

**参数选择**：

- **修改了 `.ts` 文件**：使用 `all`
- **仅修改 `.ets` 文件**：使用 `ets`

**结果处理**：

- **编译成功 ✅**：继续后续任务
- **编译失败 ❌**：根据错误信息修复后重新编译

**错误定位**：脚本报告的错误路径为模块编译时的相对路径。例如：

- `../ts-secure-utils/src/md5.ts(37,11)` - 某模块中相对路径
- `src/md5.ts(37,11)` - 模块自己的相对路径

需要根据错误信息推断项目内的绝对路径

## 清理缓存

修改后编译仍报错（如已删除的文件仍报错），可能是缓存问题：

```bash
node <skill-dir>/scripts/clean-cache.js [module-name]
```

**参数说明**：

- 无参数 - 清理所有模块缓存
- `module-name` - 仅清理指定模块（如 `im_ui_chat`）

清理后重新编译验证
