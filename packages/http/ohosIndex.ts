import { FormDataAdapter } from './src/adapter/FormDataAdapter';
import { FormDataOhosImpl } from './src/main/ets/FormDataOhosImpl';

// 复用共通导出
export * from './index';

FormDataAdapter.create = () => new FormDataOhosImpl();
