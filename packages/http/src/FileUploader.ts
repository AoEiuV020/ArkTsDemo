import axios, { AxiosProgressEvent } from 'axios';
import { FileUploadResponse, UploadFormData, FileEntity } from './types';
import { DEFAULT_BASE_URL, UPLOAD_ENDPOINT } from './constants';
import FormData from 'form-data';

export class FileUploader {
  private baseURL: string;
  private uploadEndpoint: string;

  constructor(
    baseURL: string = DEFAULT_BASE_URL,
    uploadEndpoint: string = UPLOAD_ENDPOINT,
  ) {
    this.baseURL = baseURL;
    this.uploadEndpoint = uploadEndpoint;
  }

  /**
   * 上传文件
   * @param file 要上传的文件
   * @param formData 附加的表单数据
   * @param onProgress 上传进度回调
   * @returns 上传结果
   */
  async uploadFile(
    file: any,
    formData?: UploadFormData,
    onProgress?: (progress: number) => void,
  ): Promise<FileUploadResponse> {
    const data = new FormData();

    // 如果是 FileEntity 类型，解析使用
    if (file instanceof FileEntity) {
      data.append('file', file.file, {
        filename: file.fileName,
        contentType: file.type,
      });
    } else {
      // 否则直接传给 formData
      data.append('file', file);
    }

    // 添加额外的表单数据
    if (formData) {
      Object.entries(formData).forEach(([key, value]) => {
        data.append(key, String(value));
      });
    }

    try {
      const response = await axios.post<FileUploadResponse>(
        `${this.baseURL}${this.uploadEndpoint}`,
        data,
        {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          onUploadProgress: (progressEvent: AxiosProgressEvent) => {
            if (onProgress && progressEvent.progress !== undefined) {
              onProgress(progressEvent.progress);
            }
          },
        },
      );

      return response.data;
    } catch (error) {
      if (axios.isAxiosError(error)) {
        return {
          success: false,
          message: '上传失败',
          error: error.response?.data?.message || error.message,
        };
      }

      return {
        success: false,
        message: '上传失败',
        error: error instanceof Error ? error.message : '未知错误',
      };
    }
  }
}
