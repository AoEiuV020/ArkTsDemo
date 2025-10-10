import picker from '@ohos.file.picker';
import { fileIo } from '@kit.CoreFileKit';
import { Global } from './Global';

export interface FileInfo {
  originalUri: string;
  sandboxPath: string;
  fileName: string;
  stat: fileIo.Stat;
}

export class SelectionResult {
  public readonly uriList: string[];
  public fileInfoList: FileInfo[] | null;
  public readonly cacheDir: string;

  constructor(uriList: string[]) {
    this.uriList = uriList;
    this.fileInfoList = null;
    this.cacheDir = FilePickerUtils.createCacheDir();
  }

  public get isProcessed(): boolean {
    return this.fileInfoList != null;
  }
}

export class FilePickerUtils {
  private static readonly BASE_DIR = 'FilePicker';
  private static cacheIndex = 0;

  /**
   * 选择多个文件
   */
  static async selectMultipleFiles(maxCount?: number): Promise<SelectionResult> {
    try {
      let options = new picker.DocumentSelectOptions();
      options.maxSelectNumber = maxCount;
      let documentPicker = new picker.DocumentViewPicker();

      const result = await documentPicker.select(options);

      return new SelectionResult(result);
    } catch (error) {
      throw new Error(`选择文件失败: ${error}`);
    }
  }

  /**
   * 处理选择结果，复制文件到沙盒
   */
  static async processSelectionResult(result: SelectionResult): Promise<SelectionResult> {
    if (result.isProcessed) {
      return result;
    }

    try {
      const fileInfoList: FileInfo[] = [];

      // 创建基础缓存目录结构
      const targetDir = result.cacheDir;

      // 确保目标目录存在
      await fileIo.mkdir(targetDir, true);

      // 处理每个文件
      for (const uri of result.uriList) {
        const fileInfo = await FilePickerUtils.copyFileToTargetDir(uri, targetDir);
        fileInfoList.push(fileInfo);
      }

      result.fileInfoList = fileInfoList;

      return result;
    } catch (error) {
      throw new Error(`处理选择结果失败: ${error}`);
    }
  }

  static createCacheDir() {
    const cacheDir = Global.context.cacheDir;
    const baseDir = `${cacheDir}/${FilePickerUtils.BASE_DIR}`;

    // 生成唯一的子目录名
    const subDirName = FilePickerUtils.createSubDir();
    const targetDir = `${baseDir}/${subDirName}`;
    return targetDir;
  }

  /**
   * 删除选择结果的缓存目录
   */
  static async delete(result: SelectionResult): Promise<void> {
    if (!result.isProcessed) {
      return;
    }

    try {
      await fileIo.rmdir(result.cacheDir);
      result.fileInfoList = null;
    } catch (error) {
      throw new Error(`删除缓存目录失败: ${error}`);
    }
  }

  /**
   * 复制文件到指定目录
   */
  private static async copyFileToTargetDir(uri: string, targetDir: string): Promise<FileInfo> {
    let file: fileIo.File | null = null;
    try {
      // 打开文件并获取文件信息
      file = await fileIo.open(uri, fileIo.OpenMode.READ_ONLY);
      const stat = await fileIo.stat(file.fd);

      // 目标文件路径（保持原文件名）
      const fileName = file.name;
      const sandboxPath = `${targetDir}/${fileName}`;

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
        stat: stat,
      };
    } catch (error) {
      throw new Error(`复制文件失败: ${error}`);
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