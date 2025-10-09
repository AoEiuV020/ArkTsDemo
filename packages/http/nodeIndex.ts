import { FormDataAdapter } from './src/adapter/FormDataAdapter';
import { FormDataNodeImpl } from './src/adapter/FormDataNodeImpl';

// 复用共通导出
export * from './index';

FormDataAdapter.create = () => new FormDataNodeImpl();
