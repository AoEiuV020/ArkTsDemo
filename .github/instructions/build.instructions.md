---
applyTo: '**'
---

## 编译检查规范

脚本支持从任意目录运行，无需提前cd到项目目录。

### 仅修改ets文件

```bash
node script/buildEts.js
```

### 修改了ts文件（包括同时修改ets）

```bash
node script/build.js && node script/buildEts.js
```

**注意**：ts修改可能影响ets编译，必须两个都运行
