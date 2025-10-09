export class FileEntity {
  constructor(
    /** axios支持的文件类型，支持ArrayBuffer或者鸿蒙上可以是沙盒文件，node上可以是流， **/
    public file: any,
    /** 文件名 */
    public fileName?: string,
    /** 文件类型 */
    public type?: string,
  ) {}
}

export interface FileUploadResponse {
  success: boolean;
  message: string;
  data?: {
    file?: {
      receivedName: string; // 服务器收到的文件名
      savedName: string; // 服务器保存的文件名
      mimetype: string;
      size: number;
      path: string;
    };
    formData: Record<string, any>;
  };
  error?: string;
}

export interface UploadFormData {
  [key: string]: string | number | boolean;
}
