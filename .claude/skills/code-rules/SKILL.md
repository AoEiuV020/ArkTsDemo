---
name: code-rules
description: 代码编写基础规范。所有代码文件都必须遵守的编码约束。
---

# 代码编写规范

## 模块依赖约束

**循环依赖绝对禁止，无任何例外**：

- A导入B，B不得导入A
- 通过依赖注入或事件解耦解决
- 发现循环依赖立即重构

## 文件结构约束

- **单文件单导出**：导出的每个类/接口/枚举尽量单独文件
- **文件命名**：采用PascalCase（如`IConnection.ts`、`FileUtils.ts`）
- **接口与实现分离**：接口和实现类分别放在不同文件
- **最小化暴露**：每个目录使用index统一导出，只公开必要的内容

### Index 文件规范

- **文件名**：小写i（`index.ts`或`index.ets`），禁止`Index.ts`
- **目录级导出**：子目录应有自己的index，上级通过`export * from './subdir'`引用
- **避免跨层导出**：index只导出本目录或直接子目录内容，不跨多层直接导出具体文件
- **单文件导出数量**：超过10个具名export时，考虑为子目录创建独立index

## 代码风格

- **import语句必须统一写在文件开头**：禁止在代码中间穿插import，按顺序：第三方库 → 内部模块 → 相对路径，各分组间空行分隔
- 静态成员使用类名访问，禁用this
- 设置默认值用`??`，禁止使用`||`
- 可空字段使用问号标记，禁止使用`| undefined`
- **函数返回类型为void时省略不写**
- **禁止单行转发函数**：直接调用目标函数，重构后检查是否产生了单行转发
- **统一使用`chatId`表示群组jid**：禁止使用`roomJid`
- **禁止硬编码意义不明的数字**：使用枚举（如`GroupMemberRole.Admin`）
- **禁止向后兼容代码**：修改API时直接修改，不保留deprecated别名
- **工具类使用静态类**：工具函数封装为静态类导出，禁止直接导出裸函数
- **注释只描述当前代码**：禁止描述修改过程（如"已移至"、"改为"、"原来是"）
- **禁止导出纯函数**：函数必须封装到类中作为静态方法导出

## 类型安全约束

- **避免any/unknown**：尽量使用具体类型，实在无法确定才用object
- **内存类型**：使用`Uint8Array`而不是`Buffer`（鸿蒙兼容性）
- **Protobuf类型**：基于protobuf生成的类型不重复定义
- **枚举选择**：数字枚举优于字符串枚举，无必要区分时默认自增
- **Node.js兼容**：避免Node.js特定API，优先使用鸿蒙兼容实现
- **类型导出**：使用`export type`导出类型以适配独立编译模式
- **空判断**：禁止对接口定义的非空类型做多余空判断

## 异常处理

- **禁止只打印日志后抛出的try/catch**：直接移除让异常自然传播
- **禁止空的或仅注释的catch块**
- 无法处理的错误让其自动抛出，不做无意义包装
- **维护@throws标记**：可能抛异常的函数必须在JSDoc中标注`@throws`，从源头到捕获点的整条调用链都要标注，直到被try/catch捕获为止

## 中文约束

- 代码注释、文档注释：必须中文
- 错误消息、提示消息：必须中文
- 日志输出：必须中文
- 单元测试描述：必须中文
- 标识符：变量、函数、类名等使用英文

## 日志规范

- 禁用`console.log`，必须使用logger包
- 导入：`import { createLogger } from 'logger'`
- 每个类创建独立logger：`private logger = createLogger('ClassName')`
- 静态工具类在类外创建：`const logger = createLogger('UtilityName')`
- 日志级别：debug/info/warn/error
- 日志内容使用中文

## 单例模式

### 懒加载单例（推荐）

```typescript
class XxxManager {
  static get instance(): XxxManager {
    return (XxxManager._instance ??= new XxxManager())
  }
  private static _instance?: XxxManager
}
```

### 非懒加载单例

```typescript
class XxxManagerImpl {}
export const XxxManager = new XxxManagerImpl()
```

## 代码参考约束

- **参考现有实现**：添加新功能时，先查看同类文件的现有实现方式
- **禁止凭空编造**：不确定的API用法必须先在现有代码中确认，不要猜测
- **设计验证**：理解需求后、编写代码前，反思设计是否满足每一个要求，不满足时重新设计或询问

## 文档约束

- **.md文档定位**：是给AI的提示词，不是用户文档
- **代码示例**：不超过10行，用关键代码片段说明
- **简洁性**：直接编写最终版本，不记录修改历史
- **创建限制**：没有明确要求时，禁止主动创建.md文件
