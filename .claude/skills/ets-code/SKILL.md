---
name: ets-code
description: 鸿蒙ETS代码规范。编写或修改oh_packages或entry目录下的.ets文件时使用。
---

# 鸿蒙 ETS 开发规范

## ArkTS特定限制

- 禁止使用any/unknown，必须any时使用`ESObject`
- **禁止直接throw catch捕获的error**
- 禁止使用展开运算符`...`，必须明确列出所有属性
- 禁止在构造函数参数中声明字段
- **禁止使用解构赋值声明变量**：逐个赋值
- Record 字面量的键名必须使用字符串文字（带引号）
- **禁止import鸿蒙基本注解**：如`@ObservedV2`、`@Trace`等可以直接使用

### 对象字面量规则

核心限制：**类型不明时禁止使用对象字面量**

| 场景                                | 是否允许 | 说明                    |
| ----------------------------------- | -------- | ----------------------- |
| `const obj = { a: 1 }`              | ❌       | 赋值给const，类型未知   |
| `const obj: MyInterface = { a: 1 }` | ✅       | 类型已声明              |
| `fn({ a: 1 })`                      | ✅       | 参数类型已定义          |
| `return { a: 1 }`                   | ✅       | 返回类型已定义时        |
| `fn(x: { a: number })`              | ❌       | 用字面量定义参数类型    |
| `fn(x: MyInterface)`                | ✅       | 用interface定义参数类型 |
| `fn(): { a: number }`               | ❌       | 用字面量定义返回类型    |
| `fn(): MyInterface`                 | ✅       | 用interface定义返回类型 |

## 组件开发约束

- **禁止在build方法中直接包含自定义组件**：build方法只能直接包含系统组件
- **自定义组件禁止使用泛型**
- **可空字段使用问号标记，禁止使用| undefined**
- **函数返回类型为void时省略不写**
- **@Builder装饰的UI函数禁止使用if-return写法**
- **UI函数禁止出现非UI代码**：数据处理必须在ViewModel中完成
- **列表优先使用Repeat实现**
- **Repeat中@Builder参数只能是RepeatItem**：禁止传递其他参数，正确：`this.buildItem(ri)`
- **Repeat复用不重建组件**：复用时View和ViewModel不重建、aboutToAppear不触发。ViewModel必须持有ri引用并用`@Monitor('ri.item')`响应变化，禁止在构造函数中复制item
- **条件渲染优先使用if判断**：避免使用visibility控制显隐

## 状态管理V2

- 使用@ComponentV2装饰器声明组件
- @Provider()提供状态
- @Consumer()消费状态：必须声明为可选类型，使用时非空断言
- **@Consumer字段固定带问号**

## 组件参数约束

- **@Param可空参数必须明确赋值undefined**：带`?`的`@Param`字段必须写默认值（如`@Param foo?: Type = undefined`）
- **@Param非空参数必须使用@Require**
- **@BuilderParam可空不需要默认值**：`@BuilderParam builder?: () => void`即可，传递时需要用箭头函数包装避免this错乱
- **@Event用于事件回调**
- **回调参数单独定义**：禁止使用多合一的回调接口，每个回调单独定义为`@Event`参数
- **父子组件交互通过Controller**：父组件需要操控子组件时，创建Controller实例传入子组件

## 页面跳转传参

- 使用 NavigationUtils.navigateTo 传参 Record 对象
- 使用 NavigationUtils.getNavParam 接收参数
- **可选参数使用 param.optional 读取**
- **页面传参传递字段而不是对象**
- **复杂参数封装传递**：将整个对象作为Record的一个成员传递，如`{'params': complexParams}`，接收时`param.require<MyParams>('params')`
- **联合类型参数判断**：使用`TsUtils.getField(obj, 'field') !== undefined`来检测字段是否存在

## 布局约束

- **优先使用RelativeContainer**：复杂布局使用RelativeContainer
- **禁止使用Stack**：Stack容易导致尺寸计算问题，使用RelativeContainer替代
- 每个子组件必须设置`.id('name')`和`.alignRules({})`
- **width和margin冲突**：`width('100%')`不包含margin，同时设置会导致超出屏幕。实现留白应使用外层容器的padding而不是子元素的margin

## 文本显示约束

- **maxLines(1) 必须配合 wordBreak(WordBreak.BREAK_ALL)**

## 按钮约束

- **禁止使用`.border({...})`**：会导致`.borderRadius()`失效，必须使用分离写法

## 测试约束

- 单元测试在src/test/目录，文件名`.test.ets`结尾
- 使用describe/it/expect/assert，describe不嵌套

## 继承约束

- **abstract属性不能在基类构造函数中访问**：将值作为构造函数参数传入
- **子类覆盖不能更改访问级别**：如需公开访问，基类也声明为public

## 状态管理约束

- **@Computed getter不能有setter**
