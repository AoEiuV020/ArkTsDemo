import { user } from './generated/user';

// 导出所有类型和枚举
export { user };
export type IUser = user.IUser;
export type IUserListRequest = user.IUserListRequest;
export type IUserListResponse = user.IUserListResponse;
export type ICreateUserRequest = user.ICreateUserRequest;
export type ICommonResponse = user.ICommonResponse;

// 用户角色枚举
export const UserRole = user.UserRole;

// 便捷的创建和操作类
export class UserService {
  /**
   * 创建用户对象
   */
  static createUser(data: IUser): user.User {
    return user.User.create(data);
  }

  /**
   * 编码用户为二进制数据
   */
  static encodeUser(userObj: user.User): Uint8Array {
    return user.User.encode(userObj).finish();
  }

  /**
   * 从二进制数据解码用户
   */
  static decodeUser(buffer: Uint8Array): user.User {
    return user.User.decode(buffer);
  }

  /**
   * 用户对象转换为普通对象
   */
  static userToObject(userObj: user.User): IUser {
    return user.User.toObject(userObj);
  }

  /**
   * 从JSON创建用户
   */
  static fromJSON(json: any): user.User {
    return user.User.fromObject(json);
  }

  /**
   * 用户转换为JSON
   */
  static toJSON(userObj: user.User): any {
    return user.User.toObject(userObj, {
      longs: String,
      enums: String,
      bytes: String,
    });
  }

  /**
   * 创建用户列表请求
   */
  static createUserListRequest(data: IUserListRequest): user.UserListRequest {
    return user.UserListRequest.create(data);
  }

  /**
   * 创建用户列表响应
   */
  static createUserListResponse(data: IUserListResponse): user.UserListResponse {
    return user.UserListResponse.create(data);
  }

  /**
   * 创建用户创建请求
   */
  static createCreateUserRequest(data: ICreateUserRequest): user.CreateUserRequest {
    return user.CreateUserRequest.create(data);
  }

  /**
   * 创建通用响应
   */
  static createCommonResponse(data: ICommonResponse): user.CommonResponse {
    return user.CommonResponse.create(data);
  }
}
