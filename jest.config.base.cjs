// 基础配置定义
module.exports = {
  preset: 'ts-jest/presets/default-esm',
  testEnvironment: 'node',

  // 基础的转换配置
  transform: {
    '^.+\\.ts$': [
      'ts-jest',
      {
        useESM: true,
      },
    ],
    '^.+\\.js$': [
      'ts-jest',
      {
        useESM: true,
      },
    ],
  },

  // ESM 支持
  extensionsToTreatAsEsm: ['.ts'],

  // 基础的测试匹配模式
  testMatch: ['<rootDir>/__tests__/*.test.ts'],

  // 基础的覆盖率收集配置
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.test.ts',
    '!src/test/**',
    '!src/main/**',
    '!src/ohosTest/**',
  ],

  // 基础的忽略路径
  testPathIgnorePatterns: [
    '/node_modules/',
    '/oh_modules/',
    '/dist/',
    '/.test/',
    '/build/',
    '/src/test/',
    '/src/main/',
    '/src/ohosTest/',
  ],

  // 默认根目录
  roots: ['<rootDir>/src', '<rootDir>/__tests__'],

  // 项目特定的安装文件（如果存在）
  setupFilesAfterEnv: ['<rootDir>/__tests__/setup.ts'],
};
