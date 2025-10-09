export class FormDataAdapter {
  // 静态函数对象，将在index中赋值为实际的构造函数
  public static create: () => FormDataAdapter;

  protected constructor() {
  }

  // 抽象append方法，具体实现由子类提供
  append(key: string, value: any, options?: AppendOptions): void {
    throw new Error('Method not implemented.');
  }

  getRawFormData(): any {
    throw new Error('Method not implemented.');
  }
}

export interface AppendOptions {
  filename?: string;
  type?: string;
}
