import picker from '@ohos.file.picker';
import { fileIo } from '@kit.CoreFileKit';

export interface FileInfo {
  originalUri: string;
  sandboxPath: string;
  fileName: string;
  stat: FileStatInfo;
}

export interface FileStatInfo {
  size: number;
  mode: number;
  uid: number;
  gid: number;
  atime: number;
  mtime: number;
  ctime: number;
  isFile: boolean;
  isDirectory: boolean;
  isBlockDevice: boolean;
  isCharacterDevice: boolean;
  isFIFO: boolean;
  isSocket: boolean;
  isSymbolicLink: boolean;
}

export class FilePickerUtils {
  private static readonly CACHE_DIR = 'FilePickerUtils';
  private static cacheIndex = 0;

  static async selectAndCopyFile(context: Context): Promise<FileInfo> {
    try {
      // 选择文件
      const uri = await FilePickerUtils.selectFile();
      // 复制文件到沙盒
      return await FilePickerUtils.copyFileToSandbox(uri, context);
    } catch (error) {
      throw new Error(`选择并复制文件失败: ${error}`);
    }
  }
  /**
   * 选择文件
   */
  static async selectFile(): Promise<string> {
    try {
      let DocumentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();

      const documentSelectResult = await documentPicker.select(DocumentSelectOptions);

      if (documentSelectResult && documentSelectResult.length > 0) {
        return documentSelectResult[0];
      }

      throw new Error('未选择文件');
    } catch (error) {
      throw new Error(`选择文件失败: ${error}`);
    }
  }

  /**
   * 复制选择的文件uri到沙盒缓存目录
   */
  static async copyFileToSandbox(uri: string, context: Context): Promise<FileInfo> {
    let file: fileIo.File | null = null;
    try {

      // 打开文件并获取文件信息
      file = await fileIo.open(uri, fileIo.OpenMode.READ_ONLY);
      const stat = await fileIo.stat(file.fd);
      const fileInfo: FileStatInfo = {
        size: stat.size,
        mode: stat.mode,
        uid: stat.uid,
        gid: stat.gid,
        atime: stat.atime,
        mtime: stat.mtime,
        ctime: stat.ctime,
        isFile: stat.isFile(),
        isDirectory: stat.isDirectory(),
        isBlockDevice: stat.isBlockDevice(),
        isCharacterDevice: stat.isCharacterDevice(),
        isFIFO: stat.isFIFO(),
        isSocket: stat.isSocket(),
        isSymbolicLink: stat.isSymbolicLink()
      };

      // 创建目标目录：cacheDir/uploads/timestamp.index/
      const cacheDir = context.cacheDir;
      const uploadsBaseDir = `${cacheDir}/${FilePickerUtils.CACHE_DIR}`;

      // 生成时间戳和递增索引
      const subDirName = FilePickerUtils.createSubDir();
      const uploadDir = `${uploadsBaseDir}/${subDirName}`;

      // 确保uploads基目录存在
      try {
        await fileIo.mkdir(uploadsBaseDir);
      } catch (error) {
        // 目录可能已存在，忽略错误
      }

      // 确保子目录存在
      try {
        await fileIo.mkdir(uploadDir);
      } catch (error) {
        // 目录可能已存在，忽略错误
      }

      // 目标文件路径（保持原文件名）
      const fileName = file.name;
      const sandboxPath = `${uploadDir}/${fileName}`;

      // 使用文件描述符复制文件
      try {
        await fileIo.copyFile(file.fd, sandboxPath);
      } catch (error) {
        throw new Error(`复制文件失败: ${error}`);
      }

      return {
        originalUri: uri,
        sandboxPath: sandboxPath,
        fileName: fileName,
        stat: fileInfo,
      };
    } catch (error) {
      throw new Error(`复制文件到沙盒失败: ${error}`);
    } finally {
      await FilePickerUtils.close(file);
    }
  }

  private static createSubDir() {
    const timestamp = Date.now();
    const index = ++FilePickerUtils.cacheIndex;
    const subDirName = `${timestamp}.${index}`;
    return subDirName;
  }

  /**
   * 从uri获取文件名（不包含路径）
   */
  static getFileName(uri: string): string {
    // uri需要url decode，
    return decodeURIComponent(uri.substring(uri.lastIndexOf('/') + 1));
  }

  private static async close(file: number | fileIo.File | null) {
    if (file) {
      try {
        await fileIo.close(file);
      } catch (e) {
        console.error('关闭文件失败:', e);
      }
    }
  }

}