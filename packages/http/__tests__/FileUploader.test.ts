import { FileUploader } from '../src/FileUploader';
import {
  DEFAULT_BASE_URL,
  UPLOAD_ENDPOINT,
  DEFAULT_PORT,
} from '../src/constants';

describe('FileUploader', () => {
  it('should create FileUploader instance with default values', () => {
    const uploader = new FileUploader();
    expect(uploader).toBeInstanceOf(FileUploader);
  });

  it('should create FileUploader instance with custom values', () => {
    const customURL = 'http://localhost:8080';
    const customEndpoint = '/custom-upload';
    const uploader = new FileUploader(customURL, customEndpoint);
    expect(uploader).toBeInstanceOf(FileUploader);
  });
});

describe('Constants', () => {
  it('should have correct default values', () => {
    expect(DEFAULT_PORT).toBe(3001);
    expect(DEFAULT_BASE_URL).toBe(`http://localhost:${DEFAULT_PORT}`);
    expect(UPLOAD_ENDPOINT).toBe('/upload');
  });
});
