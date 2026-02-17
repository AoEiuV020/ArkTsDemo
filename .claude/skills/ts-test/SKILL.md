---
name: ts-test
description: TypeScript单元测试技能。运行测试用例，支持完整测试、单模块、单文件、单测试等多种模式。
---

# TypeScript 单元测试

使用封装脚本运行测试，自动过滤无用输出，只显示关键信息。

## 运行完整测试

```bash
node <skill-dir>/scripts/run-test.js
```

## 按模块测试

```bash
node <skill-dir>/scripts/run-test.js --filter example
```

## 按文件测试

```bash
node <skill-dir>/scripts/run-test.js --filter example api-error.test.ts
```

## 按测试名称过滤

```bash
node <skill-dir>/scripts/run-test.js --filter example -t "ApiError"
```

## 组合使用

```bash
node <skill-dir>/scripts/run-test.js --filter example api-error.test.ts -t "ApiError"
```

## 测试文件位置

测试文件位于各 package 的 `__tests__` 目录。

## 输出格式

脚本自动过滤日志、成功case等无用信息，只输出：

- 成功模块列表
- 失败模块统计
- 每个失败测试的：原因、位置、堆栈

## 测试失败处理

1. **优先修改测试代码**：如果源代码逻辑正确，修改测试代码使其符合新行为
2. **必要时修改源代码**：如果确实是源代码bug，修复后重新运行测试
3. **修改后重新运行**：确保所有测试通过
