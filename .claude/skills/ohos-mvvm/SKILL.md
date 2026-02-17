---
name: ohos-mvvm
description: 鸿蒙ArkUI MVVM实现规范。创建/修改/重构Page、View、ViewModel时使用，包括：新增页面、添加UI组件、调整ViewModel结构、拆分子ViewModel、修改状态管理、处理生命周期等场景。
---

# 鸿蒙 MVVM 实现规范

## Model 层实现

Model 层由 SDK 模块和 DataSource 类组成：

- `ChatKitClient.im.<serviceName>` - SDK 服务访问入口
- SDK 的 Entity 类 - 业务实体
- `XxxDataSource` 类 - 封装复杂的 SDK 交互逻辑

**DataSource 规范**：

- 用于封装多步 SDK 调用或需要组合多个服务的场景
- 不持有 UI 状态（无 @Trace）
- 由 ViewModel 创建和持有

**禁止**：创建仅转发单个 SDK 调用的包装类

## 基类约束

- ViewModel层：`extends BaseViewModel`

## 状态管理V2注解

| 注解        | 用途                                   |
| ----------- | -------------------------------------- |
| @ObservedV2 | 装饰类使其可观察                       |
| @Trace      | 装饰成员变量使其可追踪，变化自动通知UI |
| @Computed   | 装饰getter定义计算属性                 |
| @Monitor    | 装饰方法监听属性变化                   |
| @Provider   | 向子组件树提供状态                     |
| @Consumer   | 接收@Provider传递的状态                |

**@Trace用法要点**：直接对@Trace的Map/Array执行修改操作即可自动触发UI刷新，无需重新赋值

## 生命周期绑定

- View在`aboutToAppear()`中调用`vm!.aboutToAppear()`
- View在`aboutToDisappear()`中调用`vm!.aboutToDisappear()`
- `BaseViewModel`已提供空实现，子类仅在需要时重写

## View层注解

- **vm字段**：`@Consumer() vm?: XxxViewModel`，声明为可空，使用时非空断言`this.vm!.xxx`

## Page层规范

- **状态提供**：`@Provider() vm?: XxxViewModel`，在onReady中创建
- **navContext**：`@Provider() navContext?: NavDestinationContext`
- **路由注册**：新增页面在`src/main/resources/base/profile/route_map.json`添加配置
- **生命周期归属**：Page只创建ViewModel，生命周期由消费它的View管理

**Provider/Consumer命名规则**：

- 默认使用字段名：`@Provider() vm` 等价于 `@Provider('vm') vm`
- 仅当字段名与所需Provider名不同时才指定别名

**多ViewModel场景**：

```typescript
@Provider() vm?: PageViewModel         // 本页View用
@Provider() reusedVm?: ReusedViewModel // 复用View用
```

## 事件通知模式

ViewModel设置状态，View监听并执行UI操作（导航、Toast等）：

- ViewModel定义状态：`@Trace navigateTo?: string`
- ViewModel设置状态：`this.navigateTo = '/targetPage'`
- View监听：使用@Monitor监控状态变化并执行UI操作
- 一次性事件字段使用后重置为undefined

## 字段可观测约束

- **@Trace仅用于会变化的字段**：只有UI需要响应变化的字段才加@Trace
- **不可变字段使用readonly**：构造后不再改变的字段务必声明为readonly
- **禁止对不变字段加@Trace**：如fromUserId、callerId等来自参数的固定值

## 实现要点

- ViewModel变量统一命名vm
- 必需参数使用非空断言，不做空判断
- 错误信息提取：ViewModel 设置 `errorMessage` 字段
