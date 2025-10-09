import { AppendOptions, FormDataAdapter } from './FormDataAdapter';
import FormData from 'form-data';

export class FormDataNodeImpl extends FormDataAdapter {
  private formData: FormData;

  constructor() {
    super();
    this.formData = new FormData();
  }

  append(key: string, value: any, options?: AppendOptions): void {
    this.formData.append(key, value, {
      filename: options?.filename,
      contentType: options?.type,
    });
  }

  getRawFormData(): FormData {
    return this.formData;
  }
}
