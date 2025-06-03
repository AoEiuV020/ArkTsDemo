import { UserRole, IUser, IUserListRequest, IUserListResponse, ICreateUserRequest, ILongTestMessage } from '../user-service';

export const mockUserData: IUser = {
  id: 1,
  name: 'John Doe',
  email: 'john.doe@example.com',
  age: 30,
  isActive: true,
  tags: ['developer', 'typescript', 'protobuf'],
  role: UserRole.USER
};

export const janeUserData: IUser = {
  id: 2,
  name: 'Jane Smith',
  email: 'jane@example.com',
  age: 25,
  isActive: false,
  tags: ['designer', 'ui/ux'],
  role: UserRole.ADMIN
};

export const complexUserData: IUser = {
  id: 999,
  name: 'Complex User 测试用户',
  email: 'complex.user@测试.com',
  age: 35,
  isActive: true,
  tags: ['测试', 'unicode', 'special-chars', '🚀'],
  role: UserRole.MODERATOR
};

export const minimalUserData: IUser = {
  id: 0,
  name: '',
  email: '',
  age: 0,
  isActive: false,
  tags: [],
  role: UserRole.UNKNOWN
};

export const userListRequestData: IUserListRequest = {
  page: 1,
  pageSize: 10,
  search: 'john'
};

export const createUserRequestData: ICreateUserRequest = {
  name: 'New User',
  email: 'newuser@example.com',
  age: 28,
  role: UserRole.USER,
  tags: ['newbie']
};

export const longTestData: ILongTestMessage = {
  signedLong: 123456789012345,
  unsignedLong: 987654321098765,
  longArray: [111111111111, 222222222222, 333333333333]
};

export const negativeLongTestData: ILongTestMessage = {
  signedLong: -123456789012345,
  unsignedLong: 987654321098765,
  longArray: [111111111111, 222222222222, 333333333333]
};

export const simpleLongTestData: ILongTestMessage = {
  signedLong: 123456789012345,
  unsignedLong: 987654321098765,
  longArray: [111111111111, 222222222222]
};

export const emptyLongTestData: ILongTestMessage = {
  signedLong: 0,
  unsignedLong: 0,
  longArray: []
};

export const largeLongTestData: ILongTestMessage = {
  signedLong: Number.MAX_SAFE_INTEGER,
  unsignedLong: Number.MAX_SAFE_INTEGER,
  longArray: [Number.MAX_SAFE_INTEGER, -Number.MAX_SAFE_INTEGER]
};