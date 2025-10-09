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

export class FileUtils {
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
      const fileName = FileUtils.getFileName(uri);

      // 打开文件并获取文件信息
      file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
      const stat = fileIo.statSync(file.fd);
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

      // 创建目标目录：cacheDir/uploads/
      const cacheDir = context.cacheDir;
      const uploadDir = `${cacheDir}/uploads`;

      // 确保uploads目录存在
      try {
        fileIo.mkdirSync(uploadDir);
      } catch (error) {
        // 目录可能已存在，忽略错误
      }

      // 目标文件路径（保持原文件名）
      const sandboxPath = `${uploadDir}/${fileName}`;

      // 使用文件描述符复制文件
      try {
        fileIo.copyFileSync(file.fd, sandboxPath);
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
      if (file) {
        try {
          fileIo.closeSync(file);
        } catch (e) {
          console.error('关闭文件失败:', e);
        }
      }
    }
  }

  /**
   * 获取文件名（不包含路径）
   */
  private static getFileName(uri: string): string {
    // uri需要url decode，
    return decodeURIComponent(uri.substring(uri.lastIndexOf('/') + 1));
  }

  /**
   * 获取文件信息（大小等），只open一次文件
   */
  private static getFileInfo(uri: string): FileStatInfo {
    let file: fileIo.File | null = null;
    try {
      file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
      const stat = fileIo.statSync(file.fd);
      return {
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
    } catch (error) {
      throw new Error(`获取文件信息失败: ${error}`);
    } finally {
      if (file) {
        try {
          fileIo.closeSync(file);
        } catch (e) {
          console.error('关闭文件失败:', e);
        }
      }
    }
  }
}