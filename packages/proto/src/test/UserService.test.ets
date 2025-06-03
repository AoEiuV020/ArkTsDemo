import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { UserService, UserRole, IUser, user } from '../user-service';
import {
  mockUserData,
  janeUserData,
  complexUserData,
  minimalUserData,
  userListRequestData,
  createUserRequestData,
  longTestData,
  negativeLongTestData,
  simpleLongTestData,
  emptyLongTestData,
  largeLongTestData
} from './TestData';

export default function userServiceTest() {
  // 全局测试数据，所有测试组共享
  let mockData: IUser;

  beforeAll(() => {
    // 初始化测试数据
    mockData = mockUserData;
  });

  describe('userServiceProtobufTests', () => {
    it('shouldCreateAUserObject', 0, () => {
      const userObj = UserService.createUser(mockData);

      // 鸿蒙不支持assertInstanceOf，改用其他断言
      expect(userObj).not().assertNull();
      expect(userObj.id).assertEqual(1);
      expect(userObj.name).assertEqual('John Doe');
      expect(userObj.email).assertEqual('john.doe@example.com');
      expect(userObj.age).assertEqual(30);
      expect(userObj.isActive).assertEqual(true);
      expect(userObj.tags.length).assertEqual(3);
      expect(userObj.tags[0]).assertEqual('developer');
      expect(userObj.role).assertEqual(UserRole.USER);
    });

    it('shouldEncodeAndDecodeUserData', 0, () => {
      const userObj = UserService.createUser(mockData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.id).assertEqual(mockData.id);
      expect(decoded.name).assertEqual(mockData.name);
      expect(decoded.email).assertEqual(mockData.email);
      expect(decoded.age).assertEqual(mockData.age);
      expect(decoded.isActive).assertEqual(mockData.isActive);
      expect(decoded.tags.length).assertEqual(mockData.tags!.length);
      expect(decoded.role).assertEqual(mockData.role);
    });

    it('shouldConvertUserToObject', 0, () => {
      const userObj = UserService.createUser(mockData);
      const plainObj = UserService.userToObject(userObj);

      expect(plainObj.id).assertEqual(1);
      expect(plainObj.name).assertEqual('John Doe');
      expect(plainObj.email).assertEqual('john.doe@example.com');
      expect(plainObj.age).assertEqual(30);
      expect(plainObj.isActive).assertEqual(true);
      expect(plainObj.role).assertEqual(UserRole.USER);
    });

    it('shouldCreateUserFromJSON', 0, () => {
      const userObj = UserService.fromJSON(janeUserData as Record<string, Object>);

      expect(userObj.id).assertEqual(2);
      expect(userObj.name).assertEqual('Jane Smith');
      expect(userObj.email).assertEqual('jane@example.com');
      expect(userObj.age).assertEqual(25);
      expect(userObj.isActive).assertEqual(false);
      expect(userObj.tags.length).assertEqual(2);
      expect(userObj.role).assertEqual(UserRole.ADMIN);
    });

    it('shouldConvertUserToJSON', 0, () => {
      const userObj = UserService.createUser(mockData);
      const json = UserService.toJSON(userObj);

      expect(json.id).assertEqual(1);
      expect(json.name).assertEqual('John Doe');
      expect(json.email).assertEqual('john.doe@example.com');
      expect(json.age).assertEqual(30);
      expect(json.isActive).assertEqual(true);
      expect(json.role).assertEqual('USER'); // 枚举转换为字符串
    });
  });

  describe('userRoleEnumTests', () => {
    it('shouldHaveCorrectEnumValues', 0, () => {
      expect(UserRole.UNKNOWN).assertEqual(0);
      expect(UserRole.USER).assertEqual(1);
      expect(UserRole.ADMIN).assertEqual(2);
      expect(UserRole.MODERATOR).assertEqual(3);
    });
  });

  describe('userListOperationsTests', () => {
    it('shouldCreateUserListRequest', 0, () => {
      const request = UserService.createUserListRequest(userListRequestData);

      expect(request.page).assertEqual(1);
      expect(request.pageSize).assertEqual(10);
      expect(request.search).assertEqual('john');
    });

    it('shouldCreateUserListResponse', 0, () => {
      const user1 = UserService.createUser(mockData);
      const user2Data: IUser = {
        id: 2,
        name: 'Jane Smith',
        email: 'jane@example.com',
        age: 25,
        isActive: true,
        tags: ['designer'],
        role: UserRole.ADMIN
      };
      const user2 = UserService.createUser(user2Data);
      const users = [user1, user2];

      const response = UserService.createUserListResponse({
        users: users,
        total: 2,
        page: 1,
        pageSize: 10
      });

      expect(response.users.length).assertEqual(2);
      expect(response.total).assertEqual(2);
      expect(response.page).assertEqual(1);
      expect(response.pageSize).assertEqual(10);
      expect(response.users[0].name).assertEqual('John Doe');
      expect(response.users[1].name).assertEqual('Jane Smith');
    });
  });

  describe('createUserRequestTests', () => {
    it('shouldCreateUserCreationRequest', 0, () => {
      const request = UserService.createCreateUserRequest(createUserRequestData);

      expect(request.name).assertEqual('New User');
      expect(request.email).assertEqual('newuser@example.com');
      expect(request.age).assertEqual(28);
      expect(request.role).assertEqual(UserRole.USER);
      expect(request.tags.length).assertEqual(1);
      expect(request.tags[0]).assertEqual('newbie');
    });
  });

  describe('binaryDataIntegrityTests', () => {
    it('shouldMaintainDataIntegrityThroughEncodeDecodeCycle', 0, () => {
      const userObj = UserService.createUser(complexUserData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.id).assertEqual(complexUserData.id);
      expect(decoded.name).assertEqual(complexUserData.name);
      expect(decoded.email).assertEqual(complexUserData.email);
      expect(decoded.age).assertEqual(complexUserData.age);
      expect(decoded.isActive).assertEqual(complexUserData.isActive);
      expect(decoded.tags.length).assertEqual(complexUserData.tags!.length);
      expect(decoded.role).assertEqual(complexUserData.role);
    });

    it('shouldHandleEmptyArraysAndDefaultValues', 0, () => {
      const userObj = UserService.createUser(minimalUserData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.id).assertEqual(0);
      expect(decoded.name).assertEqual('');
      expect(decoded.email).assertEqual('');
      expect(decoded.age).assertEqual(0);
      expect(decoded.isActive).assertEqual(false);
      expect(decoded.tags.length).assertEqual(0);
      expect(decoded.role).assertEqual(UserRole.UNKNOWN);
    });
  });

  describe('longTypeTests', () => {
    it('shouldCreateAndHandleLongTestMessageWithBasicValues', 0, () => {
      const longTestMessage = UserService.createLongTestMessage(longTestData);

      expect(longTestMessage.signedLong).not().assertNull();
      expect(longTestMessage.unsignedLong).not().assertNull();
      expect(longTestMessage.longArray.length).assertEqual(3);
    });

    it('shouldEncodeAndDecodeLongTestMessage', 0, () => {
      const longTestMessage = UserService.createLongTestMessage(negativeLongTestData);
      const encoded = UserService.encodeLongTestMessage(longTestMessage);
      const decoded = UserService.decodeLongTestMessage(encoded);

      expect(decoded.signedLong).not().assertNull();
      expect(decoded.unsignedLong).not().assertNull();
      expect(decoded.longArray.length).assertEqual(3);
    });

    it('shouldConvertLongTestMessageToObjectAndJSON', 0, () => {
      const longTestMessage = UserService.createLongTestMessage(simpleLongTestData);
      const plainObj = UserService.longTestMessageToObject(longTestMessage);
      const jsonObj = UserService.longTestMessageToJSON(longTestMessage);

      expect(plainObj).not().assertNull();
      expect(plainObj.signedLong).not().assertNull();
      expect(plainObj.unsignedLong).not().assertNull();
      expect(plainObj.longArray!.length).assertEqual(2);

      expect(jsonObj).not().assertNull();
      // Long类型在JSON中转换为字符串
      expect(typeof jsonObj.signedLong).assertEqual('string');
      expect(typeof jsonObj.unsignedLong).assertEqual('string');
    });

    it('shouldHandleEmptyLongArray', 0, () => {
      const longTestMessage = UserService.createLongTestMessage(emptyLongTestData);
      const encoded = UserService.encodeLongTestMessage(longTestMessage);
      const decoded = UserService.decodeLongTestMessage(encoded);

      expect(decoded.longArray.length).assertEqual(0);
    });

    it('shouldHandleLargeLongValues', 0, () => {
      const longTestMessage = UserService.createLongTestMessage(largeLongTestData);

      expect(longTestMessage).not().assertNull();
      expect(longTestMessage.longArray.length).assertEqual(2);
    });
  });

  describe('userWithLongTimestampsTests', () => {
    it('shouldHandleUserWithTimestampFields', 0, () => {
      const userData: IUser = {
        id: mockData.id!,
        name: mockData.name!,
        email: mockData.email!,
        age: mockData.age!,
        isActive: mockData.isActive!,
        tags: mockData.tags!,
        role: mockData.role!,
        createdTimestamp: Date.now(),
        lastLoginTimestamp: Date.now() - 86400000, // 1 day ago
        userTokenId: 999999999999999
      };

      const userObj = UserService.createUser(userData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.createdTimestamp).not().assertNull();
      expect(decoded.lastLoginTimestamp).not().assertNull();
      expect(decoded.userTokenId).not().assertNull();
    });
  });
}
