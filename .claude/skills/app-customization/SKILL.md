---
name: app-customization
description: 应用定制规范。需要修改应用名称、版本号、图标、证书、配置等时使用。
---

# 应用定制指南

## 版本信息

### 版本号配置

路径：`AppScope/app.json5`

```json5
{
  app: {
    bundleName: 'com.example.app', // 应用包名
    versionCode: 1000000, // 版本号（整数，用于升级比较）
    versionName: '1.0.0', // 版本名称（用户可见）
  },
}
```

## 应用名称

### 应用级名称

路径：`AppScope/resources/base/element/string.json`

```json
{
  "string": [{ "name": "app_name", "value": "应用名称" }]
}
```

### 模块级名称（引用应用级）

路径：`entry/src/main/resources/base/element/string.json`

`EntryAbility_label` 使用 `$string:app_name` 引用应用级名称。

## 应用图标

### 应用级图标

路径：`AppScope/resources/base/media/`

- `background.png` - 图标背景层（1024×1024）
- `foreground.png` - 图标前景层（1024×1024）

### 模块级图标

路径：`entry/src/main/resources/base/media/`

- `background.png` - 模块图标背景层
- `foreground.png` - 模块图标前景层
- `startIcon.png` - 启动窗口图标
