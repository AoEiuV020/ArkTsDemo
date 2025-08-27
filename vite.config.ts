import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    // 只运行一次测试并退出
    watch: false,

    // 指定测试文件位置
    include: ['__tests__/**/*.test.ts', 'packages/*/__tests__/**/*.test.ts'],

    // 测试环境（node/jsdom）
    environment: 'node',

    // 全局安装测试API（describe, it, expect等）
    globals: true,

    // 测试超时时间（毫秒）
    testTimeout: 10000,
  },
});
