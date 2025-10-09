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
app.post(UPLOAD_ENDPOINT, upload.single('file'), (req, res) => {
  try {
    // 设置响应编码
    res.setHeader('Content-Type', 'application/json; charset=utf-8');

    const response: FileUploadResponse = {
      success: true,
      message: '文件上传成功',
      data: {
        formData: req.body,
        file: req.file
          ? {
              receivedName: req.file.originalname, // 服务器收到的文件名
              savedName: req.file.filename, // 服务器保存的文件名
              mimetype: req.file.mimetype,
              size: req.file.size,
              path: req.file.path,
            }
          : undefined,
      },
    };

    res.json(response);
  } catch (error) {
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
