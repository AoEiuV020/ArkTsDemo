// 继承根项目的基础配置
const { baseConfig } = require('../../jest.config.cjs');

const config = {
  // 继承基础配置
  ...baseConfig,

  // 项目特定配置
  displayName: 'socket',
};
module.exports = config;
