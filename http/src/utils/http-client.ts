import axios, { AxiosError, AxiosRequestConfig, AxiosResponse } from '@ohos/axios';

export class HttpClient {
  private instance = axios.create({
    baseURL: '/api',
    timeout: 10000,
    headers: {
      'Content-Type': 'application/json',
    },
  });

  constructor() {
    this.setupInterceptors();
  }

  private setupInterceptors() {
    // 请求拦截器
    this.instance.interceptors.request.use(
      (config) => {
        // 添加认证头
        return config;
      },
      (error: AxiosError) => {
        console.error('Request error:', error.message);
        return Promise.reject(error);
      }
    );

    // 响应拦截器
    this.instance.interceptors.response.use(
      (response: AxiosResponse) => {
        return response.data;
      },
      (error: AxiosError) => {
        console.error('Response error:', error.message);

        if (error.response) {
          // 处理HTTP错误码
          switch (error.response.status) {
            case 401:
              console.log('Unauthorized, redirect to login');
              break;
            case 403:
              console.log('Forbidden');
              break;
            case 404:
              console.log('Resource not found');
              break;
            case 500:
              console.log('Server error');
              break;
          }
        }

        return Promise.reject(error);
      }
    );
  }

  // HTTP 请求方法封装
  get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.get(url, config);
  }

  post<T, D = any>(url: string, data?: D, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.post(url, data, config);
  }

  put<T, D = any>(url: string, data?: D, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.put(url, data, config);
  }

  delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    return this.instance.delete(url, config);
  }
}
