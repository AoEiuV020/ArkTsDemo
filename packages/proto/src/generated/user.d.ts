import * as $protobuf from "@ohos/protobufjs";
import Long = require("long");
/** Namespace user. */
export namespace user {

    /** Properties of a User. */
    interface IUser {

        /** User id */
        id?: (number|null);

        /** User name */
        name?: (string|null);

        /** User email */
        email?: (string|null);

        /** User age */
        age?: (number|null);

        /** User isActive */
        isActive?: (boolean|null);

        /** User tags */
        tags?: (string[]|null);

        /** User role */
        role?: (user.UserRole|null);

        /** User createdTimestamp */
        createdTimestamp?: (number|Long|null);

        /** User lastLoginTimestamp */
        lastLoginTimestamp?: (number|Long|null);

        /** User userTokenId */
        userTokenId?: (number|Long|null);
    }

    /** Represents a User. */
    class User implements IUser {

        /**
         * Constructs a new User.
         * @param [properties] Properties to set
         */
        constructor(properties?: user.IUser);

        /** User id. */
        public id: number;

        /** User name. */
        public name: string;

        /** User email. */
        public email: string;

        /** User age. */
        public age: number;

        /** User isActive. */
        public isActive: boolean;

        /** User tags. */
        public tags: string[];

        /** User role. */
        public role: user.UserRole;

        /** User createdTimestamp. */
        public createdTimestamp: (number|Long);

        /** User lastLoginTimestamp. */
        public lastLoginTimestamp: (number|Long);

        /** User userTokenId. */
        public userTokenId: (number|Long);

        /**
         * Creates a new User instance using the specified properties.
         * @param [properties] Properties to set
         * @returns User instance
         */
        public static create(properties?: user.IUser): user.User;

        /**
         * Encodes the specified User message. Does not implicitly {@link user.User.verify|verify} messages.
         * @param message User message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: user.IUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified User message, length delimited. Does not implicitly {@link user.User.verify|verify} messages.
         * @param message User message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: user.IUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a User message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): user.User;

        /**
         * Decodes a User message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): user.User;

        /**
         * Verifies a User message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a User message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns User
         */
        public static fromObject(object: { [k: string]: any }): user.User;

        /**
         * Creates a plain object from a User message. Also converts values to other types if specified.
         * @param message User
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: user.User, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this User to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for User
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** UserRole enum. */
    enum UserRole {
        UNKNOWN = 0,
        USER = 1,
        ADMIN = 2,
        MODERATOR = 3
    }

    /** Properties of a UserListRequest. */
    interface IUserListRequest {

        /** UserListRequest page */
        page?: (number|null);

        /** UserListRequest pageSize */
        pageSize?: (number|null);

        /** UserListRequest search */
        search?: (string|null);
    }

    /** Represents a UserListRequest. */
    class UserListRequest implements IUserListRequest {

        /**
         * Constructs a new UserListRequest.
         * @param [properties] Properties to set
         */
        constructor(properties?: user.IUserListRequest);

        /** UserListRequest page. */
        public page: number;

        /** UserListRequest pageSize. */
        public pageSize: number;

        /** UserListRequest search. */
        public search: string;

        /**
         * Creates a new UserListRequest instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserListRequest instance
         */
        public static create(properties?: user.IUserListRequest): user.UserListRequest;

        /**
         * Encodes the specified UserListRequest message. Does not implicitly {@link user.UserListRequest.verify|verify} messages.
         * @param message UserListRequest message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: user.IUserListRequest, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserListRequest message, length delimited. Does not implicitly {@link user.UserListRequest.verify|verify} messages.
         * @param message UserListRequest message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: user.IUserListRequest, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserListRequest message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserListRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): user.UserListRequest;

        /**
         * Decodes a UserListRequest message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserListRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): user.UserListRequest;

        /**
         * Verifies a UserListRequest message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserListRequest message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserListRequest
         */
        public static fromObject(object: { [k: string]: any }): user.UserListRequest;

        /**
         * Creates a plain object from a UserListRequest message. Also converts values to other types if specified.
         * @param message UserListRequest
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: user.UserListRequest, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserListRequest to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserListRequest
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a UserListResponse. */
    interface IUserListResponse {

        /** UserListResponse users */
        users?: (user.IUser[]|null);

        /** UserListResponse total */
        total?: (number|null);

        /** UserListResponse page */
        page?: (number|null);

        /** UserListResponse pageSize */
        pageSize?: (number|null);
    }

    /** Represents a UserListResponse. */
    class UserListResponse implements IUserListResponse {

        /**
         * Constructs a new UserListResponse.
         * @param [properties] Properties to set
         */
        constructor(properties?: user.IUserListResponse);

        /** UserListResponse users. */
        public users: user.IUser[];

        /** UserListResponse total. */
        public total: number;

        /** UserListResponse page. */
        public page: number;

        /** UserListResponse pageSize. */
        public pageSize: number;

        /**
         * Creates a new UserListResponse instance using the specified properties.
         * @param [properties] Properties to set
         * @returns UserListResponse instance
         */
        public static create(properties?: user.IUserListResponse): user.UserListResponse;

        /**
         * Encodes the specified UserListResponse message. Does not implicitly {@link user.UserListResponse.verify|verify} messages.
         * @param message UserListResponse message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: user.IUserListResponse, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified UserListResponse message, length delimited. Does not implicitly {@link user.UserListResponse.verify|verify} messages.
         * @param message UserListResponse message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: user.IUserListResponse, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a UserListResponse message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns UserListResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): user.UserListResponse;

        /**
         * Decodes a UserListResponse message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns UserListResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): user.UserListResponse;

        /**
         * Verifies a UserListResponse message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a UserListResponse message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns UserListResponse
         */
        public static fromObject(object: { [k: string]: any }): user.UserListResponse;

        /**
         * Creates a plain object from a UserListResponse message. Also converts values to other types if specified.
         * @param message UserListResponse
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: user.UserListResponse, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this UserListResponse to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for UserListResponse
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CreateUserRequest. */
    interface ICreateUserRequest {

        /** CreateUserRequest name */
        name?: (string|null);

        /** CreateUserRequest email */
        email?: (string|null);

        /** CreateUserRequest age */
        age?: (number|null);

        /** CreateUserRequest role */
        role?: (user.UserRole|null);

        /** CreateUserRequest tags */
        tags?: (string[]|null);
    }

    /** Represents a CreateUserRequest. */
    class CreateUserRequest implements ICreateUserRequest {

        /**
         * Constructs a new CreateUserRequest.
         * @param [properties] Properties to set
         */
        constructor(properties?: user.ICreateUserRequest);

        /** CreateUserRequest name. */
        public name: string;

        /** CreateUserRequest email. */
        public email: string;

        /** CreateUserRequest age. */
        public age: number;

        /** CreateUserRequest role. */
        public role: user.UserRole;

        /** CreateUserRequest tags. */
        public tags: string[];

        /**
         * Creates a new CreateUserRequest instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CreateUserRequest instance
         */
        public static create(properties?: user.ICreateUserRequest): user.CreateUserRequest;

        /**
         * Encodes the specified CreateUserRequest message. Does not implicitly {@link user.CreateUserRequest.verify|verify} messages.
         * @param message CreateUserRequest message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: user.ICreateUserRequest, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CreateUserRequest message, length delimited. Does not implicitly {@link user.CreateUserRequest.verify|verify} messages.
         * @param message CreateUserRequest message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: user.ICreateUserRequest, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CreateUserRequest message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CreateUserRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): user.CreateUserRequest;

        /**
         * Decodes a CreateUserRequest message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CreateUserRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): user.CreateUserRequest;

        /**
         * Verifies a CreateUserRequest message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CreateUserRequest message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CreateUserRequest
         */
        public static fromObject(object: { [k: string]: any }): user.CreateUserRequest;

        /**
         * Creates a plain object from a CreateUserRequest message. Also converts values to other types if specified.
         * @param message CreateUserRequest
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: user.CreateUserRequest, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CreateUserRequest to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CreateUserRequest
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a CommonResponse. */
    interface ICommonResponse {

        /** CommonResponse success */
        success?: (boolean|null);

        /** CommonResponse message */
        message?: (string|null);

        /** CommonResponse code */
        code?: (number|null);
    }

    /** Represents a CommonResponse. */
    class CommonResponse implements ICommonResponse {

        /**
         * Constructs a new CommonResponse.
         * @param [properties] Properties to set
         */
        constructor(properties?: user.ICommonResponse);

        /** CommonResponse success. */
        public success: boolean;

        /** CommonResponse message. */
        public message: string;

        /** CommonResponse code. */
        public code: number;

        /**
         * Creates a new CommonResponse instance using the specified properties.
         * @param [properties] Properties to set
         * @returns CommonResponse instance
         */
        public static create(properties?: user.ICommonResponse): user.CommonResponse;

        /**
         * Encodes the specified CommonResponse message. Does not implicitly {@link user.CommonResponse.verify|verify} messages.
         * @param message CommonResponse message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: user.ICommonResponse, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified CommonResponse message, length delimited. Does not implicitly {@link user.CommonResponse.verify|verify} messages.
         * @param message CommonResponse message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: user.ICommonResponse, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a CommonResponse message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns CommonResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): user.CommonResponse;

        /**
         * Decodes a CommonResponse message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns CommonResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): user.CommonResponse;

        /**
         * Verifies a CommonResponse message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a CommonResponse message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns CommonResponse
         */
        public static fromObject(object: { [k: string]: any }): user.CommonResponse;

        /**
         * Creates a plain object from a CommonResponse message. Also converts values to other types if specified.
         * @param message CommonResponse
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: user.CommonResponse, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this CommonResponse to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for CommonResponse
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }

    /** Properties of a LongTestMessage. */
    interface ILongTestMessage {

        /** LongTestMessage signedLong */
        signedLong?: (number|Long|null);

        /** LongTestMessage unsignedLong */
        unsignedLong?: (number|Long|null);

        /** LongTestMessage longArray */
        longArray?: ((number|Long)[]|null);
    }

    /** Represents a LongTestMessage. */
    class LongTestMessage implements ILongTestMessage {

        /**
         * Constructs a new LongTestMessage.
         * @param [properties] Properties to set
         */
        constructor(properties?: user.ILongTestMessage);

        /** LongTestMessage signedLong. */
        public signedLong: (number|Long);

        /** LongTestMessage unsignedLong. */
        public unsignedLong: (number|Long);

        /** LongTestMessage longArray. */
        public longArray: (number|Long)[];

        /**
         * Creates a new LongTestMessage instance using the specified properties.
         * @param [properties] Properties to set
         * @returns LongTestMessage instance
         */
        public static create(properties?: user.ILongTestMessage): user.LongTestMessage;

        /**
         * Encodes the specified LongTestMessage message. Does not implicitly {@link user.LongTestMessage.verify|verify} messages.
         * @param message LongTestMessage message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: user.ILongTestMessage, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified LongTestMessage message, length delimited. Does not implicitly {@link user.LongTestMessage.verify|verify} messages.
         * @param message LongTestMessage message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: user.ILongTestMessage, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a LongTestMessage message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns LongTestMessage
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): user.LongTestMessage;

        /**
         * Decodes a LongTestMessage message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns LongTestMessage
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): user.LongTestMessage;

        /**
         * Verifies a LongTestMessage message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a LongTestMessage message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns LongTestMessage
         */
        public static fromObject(object: { [k: string]: any }): user.LongTestMessage;

        /**
         * Creates a plain object from a LongTestMessage message. Also converts values to other types if specified.
         * @param message LongTestMessage
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: user.LongTestMessage, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this LongTestMessage to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };

        /**
         * Gets the default type url for LongTestMessage
         * @param [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns The default type url
         */
        public static getTypeUrl(typeUrlPrefix?: string): string;
    }
}
