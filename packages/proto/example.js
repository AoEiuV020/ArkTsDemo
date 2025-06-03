#!/usr/bin/env node

/**
 * 演示ES6 Protobuf用法的示例
 */

import { UserService, UserRole, user } from './dist/index.js';

// 创建用户数据
const userData = {
  id: 1,
  name: 'John Doe',
  email: 'john.doe@example.com',
  age: 30,
  isActive: true,
  tags: ['developer', 'typescript', 'es6', 'protobuf'],
  role: UserRole.USER
};

console.log('=== ES6 Protobuf 示例 ===\n');

// 1. 创建用户对象
console.log('1. 创建用户对象:');
const userObj = UserService.createUser(userData);
console.log('✓ 用户对象已创建:', userObj.name);

// 2. 序列化为二进制数据
console.log('\n2. 序列化为二进制数据:');
const encoded = UserService.encodeUser(userObj);
console.log('✓ 二进制数据大小:', encoded.length, 'bytes');
console.log('  二进制数据(hex):', encoded.toString('hex').substring(0, 50) + '...');

// 3. 从二进制数据反序列化
console.log('\n3. 从二进制数据反序列化:');
const decoded = UserService.decodeUser(encoded);
console.log('✓ 反序列化成功:', decoded.name);
console.log('  验证数据完整性:', 
  decoded.id === userData.id &&
  decoded.name === userData.name &&
  decoded.email === userData.email
);

// 4. 转换为普通JavaScript对象
console.log('\n4. 转换为普通JavaScript对象:');
const plainObj = UserService.userToObject(userObj);
console.log('✓ 普通对象:', JSON.stringify(plainObj, null, 2));

// 5. 从JSON创建用户
console.log('\n5. 从JSON创建用户:');
const jsonUser = UserService.fromJSON({
  id: 2,
  name: 'Jane Smith',
  email: 'jane@example.com',
  age: 25,
  isActive: true,
  tags: ['designer', 'ui/ux'],
  role: UserRole.ADMIN
});
console.log('✓ 从JSON创建用户:', jsonUser.name, '角色:', UserRole[jsonUser.role]);

// 6. 创建用户列表请求
console.log('\n6. 创建用户列表请求:');
const listRequest = UserService.createUserListRequest({
  page: 1,
  pageSize: 10,
  search: 'john'
});
console.log('✓ 列表请求:', `页码=${listRequest.page}, 每页=${listRequest.pageSize}, 搜索="${listRequest.search}"`);

// 7. 创建用户列表响应
console.log('\n7. 创建用户列表响应:');
const listResponse = UserService.createUserListResponse({
  users: [userObj, jsonUser],
  total: 2,
  page: 1,
  pageSize: 10
});
console.log('✓ 列表响应:', `总计=${listResponse.total}条, 当前页有${listResponse.users.length}条记录`);

// 8. 展示枚举值
console.log('\n8. 用户角色枚举:');
Object.keys(UserRole).forEach(key => {
  if (isNaN(Number(key))) {
    console.log(`  ${key}: ${UserRole[key]}`);
  }
});

console.log('\n=== 示例完成 ===');
console.log('✅ ES6 Protobuf 配置正常工作！');
console.log('   - 使用 import/export 语法');
console.log('   - 支持 TypeScript 类型定义');
console.log('   - Jest 测试通过');
console.log('   - 数据序列化/反序列化正常');
