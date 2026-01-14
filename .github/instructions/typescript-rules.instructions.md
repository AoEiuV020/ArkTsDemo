---
applyTo: '**'
---

## TypeScript 通用规范

### 代码风格约束

- **import语句必须统一写在文件开头**：所有import语句必须在文件最开始位置，禁止在代码中间、函数内部、方法内部等任何位置穿插import语句
- import语句按照以下顺序排列：第三方库、内部模块、相对路径导入
- 每个import分组之间用空行分隔
- 静态成员使用类名访问，禁用this
- 设置默认值用??，禁止使用||
- 可空字段使用问号标记，禁止使用| undefined
- **函数返回类型为void时直接省略不写**：如`function doSomething() {}`而不是`function doSomething(): void {}`
- **禁止单行转发函数**：不要写只有一行代码的转发函数，如`async send(msg) { await this.model.send(msg) }`，调用处应该直接调用目标函数`this.model.send(msg)`
- **统一使用chatId表示群组jid**：群组相关参数统一命名为chatId，禁止使用roomJid
- **禁止硬编码意义不明的数字**：所有有特定含义的数字常量必须使用枚举替代，禁止直接使用数字。例如：
  - ✅ 正确：`GroupMemberRole.Admin`、`GroupMemberRole.Member`
  - ❌ 错误：`type = 2`、`role === 1`
  - 必须找到或创建对应的枚举，不能靠注释说明数字含义
- **禁止向后兼容代码**：修改API、重命名类/方法时，直接修改，不保留旧的deprecated别名或兼容层

### 异常处理约束

- **禁止只打印日志后抛出的try/catch**：如果catch块只是记录日志然后重新抛出异常，应该直接移除try/catch让异常自然传播
- **禁止空的或仅注释的catch块**：如果catch块只有注释说明"错误已处理"但实际没有处理逻辑，应该移除try/catch
- 无法处理的错误让其自动抛出，不要做无意义的包装

### 加密算法

- md5/sha/hex/base64/utf8/aes各种通用加密算法都封装在库ts-secure-utils中
- 如有不足就添加到ts-secure-utils中，隐藏算法细节暴露简单api，不要直接使用第三方库

### 单例

- 使用getter获取单例比如`static get instance(): FileDownloadManager {`
- 内部使用private static \_instance变量保存实例
