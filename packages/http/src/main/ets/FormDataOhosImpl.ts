import { FormData } from '@ohos/axios';
import { AppendOptions, FormDataAdapter } from '../../adapter/FormDataAdapter';

export class FormDataOhosImpl extends FormDataAdapter {
  private formData: FormData;

  constructor() {
    super();
    this.formData = new FormData();
  }

  append(key: string, value: any, options?: AppendOptions): void {
    this.formData.append(key, value, {
      filename: options?.filename,
      type: options?.type,
    });
  }

  getRawFormData(): FormData {
    return this.formData;
  }
}
