---
applyTo: '**'
---

## 编译检查规范

**注意**：cd参数带引号，如 `cd "/path/to/root"`

### 仅修改ets文件

```bash
cd "$ROOT" && node ./script/buildEts.js
```

### 修改了ts文件（包括同时修改ets）

```bash
cd "$ROOT" && ./script/build.sh && node ./script/buildEts.js
```

**注意**：ts修改可能影响ets编译，必须两个都运行
