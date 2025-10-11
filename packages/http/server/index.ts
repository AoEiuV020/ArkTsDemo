import express from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { FileUploadResponse } from '../src/types';
import { DEFAULT_PORT, UPLOAD_ENDPOINT, UPLOADS_DIR } from '../src/constants';

const app = express();

// 配置 multer 存储
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // 每次保存文件时检查并创建目录
    const uploadsDir = path.join(__dirname, UPLOADS_DIR);
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir, { recursive: true });
    }
    cb(null, uploadsDir);
  },
  filename: (req, file, cb) => {
    // 不修改文件名，保持原名
    cb(null, file.originalname);
  },
});

const upload = multer({
  storage,
  limits: {
    fileSize: 50 * 1024 * 1024, // 50MB
  },
  fileFilter: (req, file, cb) => {
    file.originalname = Buffer.from(file.originalname, 'binary').toString(
      'utf8',
    );
    cb(null, true);
  },
});

// 中间件
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(express.static(path.join(__dirname, '../public')));

// CORS
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept, Authorization',
  );
  res.header('Access-Control-Allow-Credentials', 'true');
  next();
});

// 文件上传接口
app.post(UPLOAD_ENDPOINT, upload.any(), (req, res) => {
  try {
    console.log('📨 收到文件上传请求');
    console.log('🔗 请求URL:', req.url);
    console.log('📋 表单数据:', req.body);

    // 获取文件信息 - 支持任意字段名
    const files = req.files as Express.Multer.File[];
    const uploadedFile = files && files.length > 0 ? files[0] : null;
    if (uploadedFile) {
      console.log('📁 获取到文件信息:');
      console.log('  - 文件参数key:', uploadedFile.fieldname);
      console.log('  - 原始文件名:', uploadedFile.originalname);
      console.log('  - 文件大小:', uploadedFile.size, 'bytes');
      console.log('  - 文件类型:', uploadedFile.mimetype);
      console.log('  - 保存路径:', uploadedFile.path);
    } else {
      console.log('⚠️  未检测到文件');
    }

    // 设置响应编码
    res.setHeader('Content-Type', 'application/json; charset=utf-8');

    // 检查是否有文件上传
    if (!uploadedFile) {
      const errorResponse: FileUploadResponse = {
        success: false,
        message: '未检测到文件，请选择文件后再上传',
        error: 'No file detected',
      };
      console.log('❌ 上传失败 - 未检测到文件');
      res.status(400).json(errorResponse);
      return;
    }

    const response: FileUploadResponse = {
      success: true,
      message: '文件上传成功',
      data: {
        formData: req.body,
        file: uploadedFile
          ? {
              receivedName: uploadedFile.originalname, // 服务器收到的文件名
              savedName: uploadedFile.filename, // 服务器保存的文件名
              mimetype: uploadedFile.mimetype,
              size: uploadedFile.size,
              path: uploadedFile.path,
              fieldName: uploadedFile.fieldname, // 添加字段名信息
            }
          : undefined,
        requestInfo: {
          method: req.method,
          url: req.url,
          path: req.path,
          query: req.query,
          headers: {
            'user-agent': req.get('User-Agent'),
            'content-type': req.get('Content-Type'),
            'content-length': req.get('Content-Length'),
            'host': req.get('Host'),
            'origin': req.get('Origin'),
            'referer': req.get('Referer'),
          },
          ip: req.ip || req.connection?.remoteAddress || req.socket?.remoteAddress || 'unknown',
          protocol: req.protocol,
          timestamp: new Date().toISOString(),
        },
      },
    };

    console.log('✅ 文件保存成功!');
    if (uploadedFile) {
      console.log('💾 保存详情:');
      console.log('  - 文件名:', uploadedFile.filename);
      console.log('  - 保存位置:', uploadedFile.path);
    }

    res.json(response);
  } catch (error) {
    console.log('❌ 文件上传失败:', error);
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    const response: FileUploadResponse = {
      success: false,
      message: '文件上传失败',
      error: error instanceof Error ? error.message : '未知错误',
    };
    res.status(500).json(response);
  }
});

app.listen(DEFAULT_PORT, () => {
  console.log(`上传服务器运行在 http://localhost:${DEFAULT_PORT}`);
});
