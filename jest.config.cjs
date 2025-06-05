// 根项目配置
module.exports = {
  // 多项目配置
  projects: ['<rootDir>/packages/*/jest.config.cjs'],

  // 根级别的覆盖率收集
  collectCoverageFrom: [
    'packages/*/src/**/*.ts',
    '!packages/*/src/**/*.d.ts',
    '!packages/*/src/**/*.test.ts',
    '!packages/*/src/test/**',
    '!packages/*/src/main/**',
    '!packages/*/src/ohosTest/**',
  ],

  // 根级别的覆盖率目录
  coverageDirectory: '<rootDir>/coverage',
};
