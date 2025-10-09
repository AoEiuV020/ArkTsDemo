import axios, { AxiosProgressEvent } from '@ohos/axios';
import { FileEntity, FileUploadResponse, UploadFormData } from './types';
import { DEFAULT_BASE_URL, UPLOAD_ENDPOINT } from './constants';
import { FormDataAdapter } from './adapter/FormDataAdapter';

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
    // 兼容鸿蒙和nodejs中FormData的不同导包和参数名，
    const data = FormDataAdapter.create();

    // 如果是 FileEntity 类型，解析使用
    if (file instanceof FileEntity) {
      data.append('file', file.file, {
        filename: file.fileName,
        type: file.type,
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
        data.getRawFormData(),
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
