import { FileUploader, FileUploadResponse } from 'http';

export interface UploadConfig {
  serverUrl: string;
  uploadPath: string;
}

export class UploadUtils {
  /**
   * 上传文件
   */
  static async uploadFile(
    filePath: string,
    config: UploadConfig,
    onProgress?: (progress: number) => void
  ): Promise<FileUploadResponse> {
    const baseURL = config.serverUrl;
    const endpoint = config.uploadPath;

    const uploader = new FileUploader(baseURL, endpoint);

    return await uploader.uploadFile(
      filePath,
      {},
      onProgress
    );
  }
}