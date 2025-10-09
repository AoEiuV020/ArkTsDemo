# HTTP 上传测试模块

这个模块提供了一个完整的文件上传测试环境，包括服务器端和客户端代码，支持中文文件名和UTF-8编码。

## 目录结构

```
packages/http/
├── server/              # 服务器端代码
│   ├── index.ts        # Express 服务器
│   └── uploads/        # 上传文件存储目录（自动创建）
├── client/             # 客户端代码
│   └── test-upload.ts  # 真实客户端测试（不导出）
├── public/             # 静态文件
│   └── index.html      # 上传测试页面
├── src/                # 通用代码
│   ├── FileUploader.ts # 上传工具类
│   ├── types.ts        # 类型定义和 FileEntity 类
│   └── constants.ts    # 常量配置
└── __tests__/          # 测试代码
    └── FileUploader.test.ts
```

## 特性

- ✅ 支持中文文件名和UTF-8编码
- ✅ 可配置的上传端点和服务器地址
- ✅ 带进度回调的文件上传
- ✅ FileEntity 封装，支持多种文件类型
- ✅ 完整的类型定义
- ✅ 每次上传时自动创建目录
- ✅ 统一的常量管理
- ✅ 服务器返回收到和保存的文件名对比

## 安装依赖

```bash
cd packages/http
pnpm install
```

## 使用方法

### 1. 启动服务器

```bash
pnpm run server
```

服务器将在 http://localhost:3001 启动

### 2. 使用网页上传

访问 http://localhost:3001 查看上传测试页面

### 3. 运行客户端测试

```bash
# 上传默认文件（README.md）
pnpm run test-client

# 上传指定文件
pnpm run test-client /path/to/your/file.txt

# 上传中文文件名测试
pnpm run test-client "/path/to/测试文件.jpg"
```

这个测试会：
- 上传指定的文件或默认的 README.md
- 附带包含中文的表单数据
- 验证文件名和大小是否正确
- 检查服务器收到和保存的文件名是否一致

### 4. 使用客户端工具类

```typescript
import { FileUploader, FileEntity, DEFAULT_BASE_URL, UPLOAD_ENDPOINT } from 'http';

const uploader = new FileUploader(DEFAULT_BASE_URL, UPLOAD_ENDPOINT);

// 方式1：使用 FileEntity（推荐）
const fileEntity = new FileEntity(
  fileContent,  // ArrayBuffer、Blob、Stream 等
  'example.txt',
  'text/plain'
);

const response = await uploader.uploadFile(
  fileEntity, 
  { 
    title: '测试文件', 
    description: '这是一个包含中文的测试描述',
    category: '文档类别'
  },
  (progress) => console.log(`上传进度: ${progress}%`)
);

// 方式2：直接传入文件对象
const response2 = await uploader.uploadFile(
  file,  // File、Blob 等 axios 支持的类型
  { 
    title: '测试文件', 
    description: '这是一个包含中文的测试描述',
    category: '文档类别'
  },
  (progress) => console.log(`上传进度: ${progress}%`)
);

if (response.success) {
  console.log('上传成功:', response.data);
} else {
  console.error('上传失败:', response.error);
}
```

## API 接口

### POST /upload

上传文件接口

**请求:**
- Content-Type: `multipart/form-data`
- 文件字段: `file` (单文件)
- 支持额外的表单数据字段

**响应:**
```json
{
  "success": true,
  "message": "文件上传成功",
  "data": {
    "file": {
      "receivedName": "example.txt",    // 服务器收到的文件名
      "savedName": "example.txt",       // 服务器保存的文件名
      "mimetype": "text/plain",
      "size": 1024,
      "path": "/path/to/uploads/example.txt"
    },
    "formData": {
      "title": "测试标题",
      "description": "测试描述"
    }
  }
}
```

## FileEntity 类

```typescript
export class FileEntity {
  constructor(
    /** axios支持的文件类型，支持ArrayBuffer或者鸿蒙上可以是沙盒文件，node上可以是流 **/
    public file: any,
    /** 文件名 */
    public fileName?: string,
    /** 文件类型 */
    public type?: string,
  ) {}
}
```

## 配置

所有配置都在 `src/constants.ts` 中统一管理：

```typescript
export const DEFAULT_PORT = 3001;
export const DEFAULT_BASE_URL = `http://localhost:${DEFAULT_PORT}`;
export const UPLOAD_ENDPOINT = '/upload';
export const UPLOADS_DIR = 'uploads';
```

## 清理

```bash
# 清理上传的文件
pnpm run clean
```

## 运行单元测试

```bash
pnpm test
```

## 编码支持

- 服务器端配置了UTF-8编码支持
- 文件名保持原样，不添加时间戳
- 表单数据支持中文内容
- 响应头设置正确的字符集
- 服务器返回收到和保存的文件名，用于验证一致性

## 注意事项

1. 服务器在每次上传时才创建 uploads 目录，不在启动时创建
2. 文件名保持原样，支持中文文件名
3. 使用 FileEntity 可以更好地控制文件上传参数
4. 客户端测试支持命令行参数指定上传文件