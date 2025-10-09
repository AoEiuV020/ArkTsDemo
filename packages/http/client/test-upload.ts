import { FileUploader } from '../src/FileUploader';
import { FileEntity } from '../src/types';
import { DEFAULT_BASE_URL } from '../src/constants';
import fs from 'fs';
import path from 'path';

async function testFileUpload() {
  const uploader = new FileUploader(DEFAULT_BASE_URL);

  // 获取文件路径，从命令行参数或默认 README.md
  const filePath = process.argv[2] || path.join(__dirname, '../README.md');
  const fileName = path.basename(filePath);

  if (!fs.existsSync(filePath)) {
    console.error(`文件不存在: ${filePath}`);
    return;
  }

  // 读取文件信息
  const fileStats = fs.statSync(filePath);

  // 使用 FileEntity
  const file = new FileEntity(
    fs.createReadStream(filePath),
    fileName,
    undefined, // 不指定类型，让服务器自动判断
  );

  // 表单数据
  const formData = {
    title: `${fileName}测试`,
    description: '这是一个包含中文的测试描述',
    category: '文档类别',
  };

  try {
    const result = await uploader.uploadFile(file, formData, progress => {
      const percentage = Math.round(progress * 100);
      console.log(`上传进度: ${percentage}%`);
    });

    console.log('服务器响应:');
    console.log(JSON.stringify(result, null, 2));

    // 只打印有问题的对比
    if (result.success && result.data?.file) {
      const receivedName = result.data.file.receivedName;
      const savedName = result.data.file.savedName;
      const size = result.data.file.size;

      if (receivedName !== fileName) {
        console.log(
          `❌ 收到文件名不匹配: 期望 '${fileName}', 实际 '${receivedName}'`,
        );
      }
      if (savedName !== fileName) {
        console.log(
          `❌ 保存文件名不匹配: 期望 '${fileName}', 实际 '${savedName}'`,
        );
      }
      if (receivedName !== savedName) {
        console.log(
          `❌ 两个文件名不一致: 收到 '${receivedName}', 保存 '${savedName}'`,
        );
      }
      if (size !== fileStats.size) {
        console.log(`❌ 文件大小不匹配: 期望 ${fileStats.size}, 实际 ${size}`);
      }

      // 如果都没问题，就简单提示
      if (
        receivedName === fileName &&
        savedName === fileName &&
        receivedName === savedName &&
        size === fileStats.size
      ) {
        console.log('✅ 文件信息验证通过');
      }
    }
  } catch (error) {
    console.error('测试失败:', error instanceof Error ? error.message : error);
  }
}

if (require.main === module) {
  testFileUpload();
}
