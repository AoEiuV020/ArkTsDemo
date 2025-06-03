import { UserService, UserRole, IUser } from '../src/user-service';

describe('UserService Protobuf Tests', () => {
  const mockUserData: IUser = {
    id: 1,
    name: 'John Doe',
    email: 'john.doe@example.com',
    age: 30,
    isActive: true,
    tags: ['developer', 'typescript', 'protobuf'],
    role: UserRole.USER
  };

  describe('User Creation and Serialization', () => {
    test('should create a user object', () => {
      const userObj = UserService.createUser(mockUserData);
      
      expect(userObj).toBeDefined();
      expect(userObj.id).toBe(1);
      expect(userObj.name).toBe('John Doe');
      expect(userObj.email).toBe('john.doe@example.com');
      expect(userObj.age).toBe(30);
      expect(userObj.isActive).toBe(true);
      expect(userObj.tags).toEqual(['developer', 'typescript', 'protobuf']);
      expect(userObj.role).toBe(UserRole.USER);
    });

    test('should encode and decode user data', () => {
      const userObj = UserService.createUser(mockUserData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.id).toBe(mockUserData.id);
      expect(decoded.name).toBe(mockUserData.name);
      expect(decoded.email).toBe(mockUserData.email);
      expect(decoded.age).toBe(mockUserData.age);
      expect(decoded.isActive).toBe(mockUserData.isActive);
      expect(decoded.tags).toEqual(mockUserData.tags);
      expect(decoded.role).toBe(mockUserData.role);
    });

    test('should convert user to object', () => {
      const userObj = UserService.createUser(mockUserData);
      const plainObj = UserService.userToObject(userObj);

      expect(plainObj).toEqual(expect.objectContaining({
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        age: 30,
        isActive: true,
        tags: ['developer', 'typescript', 'protobuf'],
        role: UserRole.USER
      }));
    });    test('should create user from JSON', () => {
      const jsonData: Record<string, Object> = {
        id: 2,
        name: 'Jane Smith',
        email: 'jane@example.com',
        age: 25,
        isActive: false,
        tags: ['designer', 'ui/ux'],
        role: UserRole.ADMIN
      };

      const userObj = UserService.fromJSON(jsonData);
      
      expect(userObj.id).toBe(2);
      expect(userObj.name).toBe('Jane Smith');
      expect(userObj.email).toBe('jane@example.com');
      expect(userObj.age).toBe(25);
      expect(userObj.isActive).toBe(false);
      expect(userObj.tags).toEqual(['designer', 'ui/ux']);
      expect(userObj.role).toBe(UserRole.ADMIN);
    });

    test('should convert user to JSON', () => {
      const userObj = UserService.createUser(mockUserData);
      const json = UserService.toJSON(userObj);

      expect(json).toEqual(expect.objectContaining({
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        age: 30,
        isActive: true,
        tags: ['developer', 'typescript', 'protobuf'],
        role: 'USER'
      }));
    });
  });

  describe('UserRole Enum', () => {
    test('should have correct enum values', () => {
      expect(UserRole.UNKNOWN).toBe(0);
      expect(UserRole.USER).toBe(1);
      expect(UserRole.ADMIN).toBe(2);
      expect(UserRole.MODERATOR).toBe(3);
    });
  });

  describe('User List Operations', () => {
    test('should create user list request', () => {
      const requestData = {
        page: 1,
        pageSize: 10,
        search: 'john'
      };

      const request = UserService.createUserListRequest(requestData);
      
      expect(request.page).toBe(1);
      expect(request.pageSize).toBe(10);
      expect(request.search).toBe('john');
    });

    test('should create user list response', () => {
      const users = [
        UserService.createUser(mockUserData),
        UserService.createUser({
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
          age: 25,
          isActive: true,
          tags: ['designer'],
          role: UserRole.ADMIN
        })
      ];

      const responseData = {
        users: users,
        total: 2,
        page: 1,
        pageSize: 10
      };

      const response = UserService.createUserListResponse(responseData);
      
      expect(response.users).toHaveLength(2);
      expect(response.total).toBe(2);
      expect(response.page).toBe(1);
      expect(response.pageSize).toBe(10);
      expect(response.users[0].name).toBe('John Doe');
      expect(response.users[1].name).toBe('Jane Smith');
    });
  });

  describe('Create User Request', () => {
    test('should create user creation request', () => {
      const requestData = {
        name: 'New User',
        email: 'newuser@example.com',
        age: 28,
        role: UserRole.USER,
        tags: ['newbie']
      };

      const request = UserService.createCreateUserRequest(requestData);
      
      expect(request.name).toBe('New User');
      expect(request.email).toBe('newuser@example.com');
      expect(request.age).toBe(28);
      expect(request.role).toBe(UserRole.USER);
      expect(request.tags).toEqual(['newbie']);
    });
  });

  describe('Binary Data Integrity', () => {
    test('should maintain data integrity through encode/decode cycle', () => {
      const complexUserData: IUser = {
        id: 999,
        name: 'Complex User 测试用户',
        email: 'complex.user@测试.com',
        age: 35,
        isActive: true,
        tags: ['测试', 'unicode', 'special-chars', '🚀'],
        role: UserRole.MODERATOR
      };

      const userObj = UserService.createUser(complexUserData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.id).toBe(complexUserData.id);
      expect(decoded.name).toBe(complexUserData.name);
      expect(decoded.email).toBe(complexUserData.email);
      expect(decoded.age).toBe(complexUserData.age);
      expect(decoded.isActive).toBe(complexUserData.isActive);
      expect(decoded.tags).toEqual(complexUserData.tags);
      expect(decoded.role).toBe(complexUserData.role);
    });

    test('should handle empty arrays and default values', () => {
      const minimalUserData: IUser = {
        id: 0,
        name: '',
        email: '',
        age: 0,
        isActive: false,
        tags: [],
        role: UserRole.UNKNOWN
      };

      const userObj = UserService.createUser(minimalUserData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.id).toBe(0);
      expect(decoded.name).toBe('');
      expect(decoded.email).toBe('');
      expect(decoded.age).toBe(0);
      expect(decoded.isActive).toBe(false);
      expect(decoded.tags).toEqual([]);      expect(decoded.role).toBe(UserRole.UNKNOWN);
    });
  });

  describe('Long Type Tests', () => {
    test('should create and handle LongTestMessage with basic values', () => {
      const longTestData = {
        signedLong: 123456789012345,
        unsignedLong: 987654321098765,
        longArray: [111111111111, 222222222222, 333333333333]
      };

      const longTestMessage = UserService.createLongTestMessage(longTestData);
      
      expect(longTestMessage.signedLong).toBeDefined();
      expect(longTestMessage.unsignedLong).toBeDefined();
      expect(longTestMessage.longArray).toHaveLength(3);
    });

    test('should encode and decode LongTestMessage', () => {
      const longTestData = {
        signedLong: -123456789012345,
        unsignedLong: 987654321098765,
        longArray: [111111111111, 222222222222, 333333333333]
      };

      const longTestMessage = UserService.createLongTestMessage(longTestData);
      const encoded = UserService.encodeLongTestMessage(longTestMessage);
      const decoded = UserService.decodeLongTestMessage(encoded);

      expect(decoded.signedLong).toBeDefined();
      expect(decoded.unsignedLong).toBeDefined();
      expect(decoded.longArray).toHaveLength(3);
    });

    test('should convert LongTestMessage to object and JSON', () => {
      const longTestData = {
        signedLong: 123456789012345,
        unsignedLong: 987654321098765,
        longArray: [111111111111, 222222222222]
      };

      const longTestMessage = UserService.createLongTestMessage(longTestData);
      const plainObj = UserService.longTestMessageToObject(longTestMessage);
      const jsonObj = UserService.longTestMessageToJSON(longTestMessage);

      expect(plainObj).toBeDefined();
      expect(plainObj.signedLong).toBeDefined();
      expect(plainObj.unsignedLong).toBeDefined();
      expect(plainObj.longArray).toHaveLength(2);

      expect(jsonObj).toBeDefined();
      expect(typeof jsonObj.signedLong).toBe('string'); // Long转换为字符串
      expect(typeof jsonObj.unsignedLong).toBe('string');
    });

    test('should handle empty long array', () => {
      const longTestData = {
        signedLong: 0,
        unsignedLong: 0,
        longArray: []
      };

      const longTestMessage = UserService.createLongTestMessage(longTestData);
      const encoded = UserService.encodeLongTestMessage(longTestMessage);
      const decoded = UserService.decodeLongTestMessage(encoded);

      expect(decoded.longArray).toEqual([]);
    });

    test('should handle large long values', () => {
      const longTestData = {
        signedLong: Number.MAX_SAFE_INTEGER,
        unsignedLong: Number.MAX_SAFE_INTEGER,
        longArray: [Number.MAX_SAFE_INTEGER, -Number.MAX_SAFE_INTEGER]
      };

      const longTestMessage = UserService.createLongTestMessage(longTestData);
      
      expect(longTestMessage).toBeDefined();
      expect(longTestMessage.longArray).toHaveLength(2);
    });
  });

  describe('User with Long timestamps', () => {
    test('should handle user with timestamp fields', () => {
      const userData = {
        ...mockUserData,
        createdTimestamp: Date.now(),
        lastLoginTimestamp: Date.now() - 86400000, // 1 day ago
        userTokenId: 999999999999999
      };
      
      const userObj = UserService.createUser(userData);
      const encoded = UserService.encodeUser(userObj);
      const decoded = UserService.decodeUser(encoded);

      expect(decoded.createdTimestamp).toBeDefined();
      expect(decoded.lastLoginTimestamp).toBeDefined();
      expect(decoded.userTokenId).toBeDefined();
    });
  });
});
