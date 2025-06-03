/*eslint-disable block-scoped-var, id-length, no-control-regex, no-magic-numbers, no-prototype-builtins, no-redeclare, no-shadow, no-var, sort-vars*/
import * as $protobuf from "@ohos/protobufjs";
import Long from 'long';
$protobuf.util.Long=Long
$protobuf.configure()
// Common aliases
const $Reader = $protobuf.Reader, $Writer = $protobuf.Writer, $util = $protobuf.util;

// Exported root namespace
const $root = $protobuf.roots["default"] || ($protobuf.roots["default"] = {});

export const user = $root.user = (() => {

    /**
     * Namespace user.
     * @exports user
     * @namespace
     */
    const user = {};

    user.User = (function() {

        /**
         * Properties of a User.
         * @memberof user
         * @interface IUser
         * @property {number|null} [id] User id
         * @property {string|null} [name] User name
         * @property {string|null} [email] User email
         * @property {number|null} [age] User age
         * @property {boolean|null} [isActive] User isActive
         * @property {Array.<string>|null} [tags] User tags
         * @property {user.UserRole|null} [role] User role
         * @property {number|Long|null} [createdTimestamp] User createdTimestamp
         * @property {number|Long|null} [lastLoginTimestamp] User lastLoginTimestamp
         * @property {number|Long|null} [userTokenId] User userTokenId
         */

        /**
         * Constructs a new User.
         * @memberof user
         * @classdesc Represents a User.
         * @implements IUser
         * @constructor
         * @param {user.IUser=} [properties] Properties to set
         */
        function User(properties) {
            this.tags = [];
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * User id.
         * @member {number} id
         * @memberof user.User
         * @instance
         */
        User.prototype.id = 0;

        /**
         * User name.
         * @member {string} name
         * @memberof user.User
         * @instance
         */
        User.prototype.name = "";

        /**
         * User email.
         * @member {string} email
         * @memberof user.User
         * @instance
         */
        User.prototype.email = "";

        /**
         * User age.
         * @member {number} age
         * @memberof user.User
         * @instance
         */
        User.prototype.age = 0;

        /**
         * User isActive.
         * @member {boolean} isActive
         * @memberof user.User
         * @instance
         */
        User.prototype.isActive = false;

        /**
         * User tags.
         * @member {Array.<string>} tags
         * @memberof user.User
         * @instance
         */
        User.prototype.tags = $util.emptyArray;

        /**
         * User role.
         * @member {user.UserRole} role
         * @memberof user.User
         * @instance
         */
        User.prototype.role = 0;

        /**
         * User createdTimestamp.
         * @member {number|Long} createdTimestamp
         * @memberof user.User
         * @instance
         */
        User.prototype.createdTimestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * User lastLoginTimestamp.
         * @member {number|Long} lastLoginTimestamp
         * @memberof user.User
         * @instance
         */
        User.prototype.lastLoginTimestamp = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * User userTokenId.
         * @member {number|Long} userTokenId
         * @memberof user.User
         * @instance
         */
        User.prototype.userTokenId = $util.Long ? $util.Long.fromBits(0,0,true) : 0;

        /**
         * Creates a new User instance using the specified properties.
         * @function create
         * @memberof user.User
         * @static
         * @param {user.IUser=} [properties] Properties to set
         * @returns {user.User} User instance
         */
        User.create = function create(properties) {
            return new User(properties);
        };

        /**
         * Encodes the specified User message. Does not implicitly {@link user.User.verify|verify} messages.
         * @function encode
         * @memberof user.User
         * @static
         * @param {user.IUser} message User message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        User.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.id != null && Object.hasOwnProperty.call(message, "id"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.id);
            if (message.name != null && Object.hasOwnProperty.call(message, "name"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.name);
            if (message.email != null && Object.hasOwnProperty.call(message, "email"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.email);
            if (message.age != null && Object.hasOwnProperty.call(message, "age"))
                writer.uint32(/* id 4, wireType 0 =*/32).int32(message.age);
            if (message.isActive != null && Object.hasOwnProperty.call(message, "isActive"))
                writer.uint32(/* id 5, wireType 0 =*/40).bool(message.isActive);
            if (message.tags != null && message.tags.length)
                for (let i = 0; i < message.tags.length; ++i)
                    writer.uint32(/* id 6, wireType 2 =*/50).string(message.tags[i]);
            if (message.role != null && Object.hasOwnProperty.call(message, "role"))
                writer.uint32(/* id 7, wireType 0 =*/56).int32(message.role);
            if (message.createdTimestamp != null && Object.hasOwnProperty.call(message, "createdTimestamp"))
                writer.uint32(/* id 8, wireType 0 =*/64).int64(message.createdTimestamp);
            if (message.lastLoginTimestamp != null && Object.hasOwnProperty.call(message, "lastLoginTimestamp"))
                writer.uint32(/* id 9, wireType 0 =*/72).int64(message.lastLoginTimestamp);
            if (message.userTokenId != null && Object.hasOwnProperty.call(message, "userTokenId"))
                writer.uint32(/* id 10, wireType 0 =*/80).uint64(message.userTokenId);
            return writer;
        };

        /**
         * Encodes the specified User message, length delimited. Does not implicitly {@link user.User.verify|verify} messages.
         * @function encodeDelimited
         * @memberof user.User
         * @static
         * @param {user.IUser} message User message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        User.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a User message from the specified reader or buffer.
         * @function decode
         * @memberof user.User
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {user.User} User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        User.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.user.User();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.id = reader.int32();
                        break;
                    }
                case 2: {
                        message.name = reader.string();
                        break;
                    }
                case 3: {
                        message.email = reader.string();
                        break;
                    }
                case 4: {
                        message.age = reader.int32();
                        break;
                    }
                case 5: {
                        message.isActive = reader.bool();
                        break;
                    }
                case 6: {
                        if (!(message.tags && message.tags.length))
                            message.tags = [];
                        message.tags.push(reader.string());
                        break;
                    }
                case 7: {
                        message.role = reader.int32();
                        break;
                    }
                case 8: {
                        message.createdTimestamp = reader.int64();
                        break;
                    }
                case 9: {
                        message.lastLoginTimestamp = reader.int64();
                        break;
                    }
                case 10: {
                        message.userTokenId = reader.uint64();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a User message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof user.User
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {user.User} User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        User.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a User message.
         * @function verify
         * @memberof user.User
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        User.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.id != null && message.hasOwnProperty("id"))
                if (!$util.isInteger(message.id))
                    return "id: integer expected";
            if (message.name != null && message.hasOwnProperty("name"))
                if (!$util.isString(message.name))
                    return "name: string expected";
            if (message.email != null && message.hasOwnProperty("email"))
                if (!$util.isString(message.email))
                    return "email: string expected";
            if (message.age != null && message.hasOwnProperty("age"))
                if (!$util.isInteger(message.age))
                    return "age: integer expected";
            if (message.isActive != null && message.hasOwnProperty("isActive"))
                if (typeof message.isActive !== "boolean")
                    return "isActive: boolean expected";
            if (message.tags != null && message.hasOwnProperty("tags")) {
                if (!Array.isArray(message.tags))
                    return "tags: array expected";
                for (let i = 0; i < message.tags.length; ++i)
                    if (!$util.isString(message.tags[i]))
                        return "tags: string[] expected";
            }
            if (message.role != null && message.hasOwnProperty("role"))
                switch (message.role) {
                default:
                    return "role: enum value expected";
                case 0:
                case 1:
                case 2:
                case 3:
                    break;
                }
            if (message.createdTimestamp != null && message.hasOwnProperty("createdTimestamp"))
                if (!$util.isInteger(message.createdTimestamp) && !(message.createdTimestamp && $util.isInteger(message.createdTimestamp.low) && $util.isInteger(message.createdTimestamp.high)))
                    return "createdTimestamp: integer|Long expected";
            if (message.lastLoginTimestamp != null && message.hasOwnProperty("lastLoginTimestamp"))
                if (!$util.isInteger(message.lastLoginTimestamp) && !(message.lastLoginTimestamp && $util.isInteger(message.lastLoginTimestamp.low) && $util.isInteger(message.lastLoginTimestamp.high)))
                    return "lastLoginTimestamp: integer|Long expected";
            if (message.userTokenId != null && message.hasOwnProperty("userTokenId"))
                if (!$util.isInteger(message.userTokenId) && !(message.userTokenId && $util.isInteger(message.userTokenId.low) && $util.isInteger(message.userTokenId.high)))
                    return "userTokenId: integer|Long expected";
            return null;
        };

        /**
         * Creates a User message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof user.User
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {user.User} User
         */
        User.fromObject = function fromObject(object) {
            if (object instanceof $root.user.User)
                return object;
            let message = new $root.user.User();
            if (object.id != null)
                message.id = object.id | 0;
            if (object.name != null)
                message.name = String(object.name);
            if (object.email != null)
                message.email = String(object.email);
            if (object.age != null)
                message.age = object.age | 0;
            if (object.isActive != null)
                message.isActive = Boolean(object.isActive);
            if (object.tags) {
                if (!Array.isArray(object.tags))
                    throw TypeError(".user.User.tags: array expected");
                message.tags = [];
                for (let i = 0; i < object.tags.length; ++i)
                    message.tags[i] = String(object.tags[i]);
            }
            switch (object.role) {
            default:
                if (typeof object.role === "number") {
                    message.role = object.role;
                    break;
                }
                break;
            case "UNKNOWN":
            case 0:
                message.role = 0;
                break;
            case "USER":
            case 1:
                message.role = 1;
                break;
            case "ADMIN":
            case 2:
                message.role = 2;
                break;
            case "MODERATOR":
            case 3:
                message.role = 3;
                break;
            }
            if (object.createdTimestamp != null)
                if ($util.Long)
                    (message.createdTimestamp = $util.Long.fromValue(object.createdTimestamp)).unsigned = false;
                else if (typeof object.createdTimestamp === "string")
                    message.createdTimestamp = parseInt(object.createdTimestamp, 10);
                else if (typeof object.createdTimestamp === "number")
                    message.createdTimestamp = object.createdTimestamp;
                else if (typeof object.createdTimestamp === "object")
                    message.createdTimestamp = new $util.LongBits(object.createdTimestamp.low >>> 0, object.createdTimestamp.high >>> 0).toNumber();
            if (object.lastLoginTimestamp != null)
                if ($util.Long)
                    (message.lastLoginTimestamp = $util.Long.fromValue(object.lastLoginTimestamp)).unsigned = false;
                else if (typeof object.lastLoginTimestamp === "string")
                    message.lastLoginTimestamp = parseInt(object.lastLoginTimestamp, 10);
                else if (typeof object.lastLoginTimestamp === "number")
                    message.lastLoginTimestamp = object.lastLoginTimestamp;
                else if (typeof object.lastLoginTimestamp === "object")
                    message.lastLoginTimestamp = new $util.LongBits(object.lastLoginTimestamp.low >>> 0, object.lastLoginTimestamp.high >>> 0).toNumber();
            if (object.userTokenId != null)
                if ($util.Long)
                    (message.userTokenId = $util.Long.fromValue(object.userTokenId)).unsigned = true;
                else if (typeof object.userTokenId === "string")
                    message.userTokenId = parseInt(object.userTokenId, 10);
                else if (typeof object.userTokenId === "number")
                    message.userTokenId = object.userTokenId;
                else if (typeof object.userTokenId === "object")
                    message.userTokenId = new $util.LongBits(object.userTokenId.low >>> 0, object.userTokenId.high >>> 0).toNumber(true);
            return message;
        };

        /**
         * Creates a plain object from a User message. Also converts values to other types if specified.
         * @function toObject
         * @memberof user.User
         * @static
         * @param {user.User} message User
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        User.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.arrays || options.defaults)
                object.tags = [];
            if (options.defaults) {
                object.id = 0;
                object.name = "";
                object.email = "";
                object.age = 0;
                object.isActive = false;
                object.role = options.enums === String ? "UNKNOWN" : 0;
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.createdTimestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.createdTimestamp = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.lastLoginTimestamp = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.lastLoginTimestamp = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    let long = new $util.Long(0, 0, true);
                    object.userTokenId = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.userTokenId = options.longs === String ? "0" : 0;
            }
            if (message.id != null && message.hasOwnProperty("id"))
                object.id = message.id;
            if (message.name != null && message.hasOwnProperty("name"))
                object.name = message.name;
            if (message.email != null && message.hasOwnProperty("email"))
                object.email = message.email;
            if (message.age != null && message.hasOwnProperty("age"))
                object.age = message.age;
            if (message.isActive != null && message.hasOwnProperty("isActive"))
                object.isActive = message.isActive;
            if (message.tags && message.tags.length) {
                object.tags = [];
                for (let j = 0; j < message.tags.length; ++j)
                    object.tags[j] = message.tags[j];
            }
            if (message.role != null && message.hasOwnProperty("role"))
                object.role = options.enums === String ? $root.user.UserRole[message.role] === undefined ? message.role : $root.user.UserRole[message.role] : message.role;
            if (message.createdTimestamp != null && message.hasOwnProperty("createdTimestamp"))
                if (typeof message.createdTimestamp === "number")
                    object.createdTimestamp = options.longs === String ? String(message.createdTimestamp) : message.createdTimestamp;
                else
                    object.createdTimestamp = options.longs === String ? $util.Long.prototype.toString.call(message.createdTimestamp) : options.longs === Number ? new $util.LongBits(message.createdTimestamp.low >>> 0, message.createdTimestamp.high >>> 0).toNumber() : message.createdTimestamp;
            if (message.lastLoginTimestamp != null && message.hasOwnProperty("lastLoginTimestamp"))
                if (typeof message.lastLoginTimestamp === "number")
                    object.lastLoginTimestamp = options.longs === String ? String(message.lastLoginTimestamp) : message.lastLoginTimestamp;
                else
                    object.lastLoginTimestamp = options.longs === String ? $util.Long.prototype.toString.call(message.lastLoginTimestamp) : options.longs === Number ? new $util.LongBits(message.lastLoginTimestamp.low >>> 0, message.lastLoginTimestamp.high >>> 0).toNumber() : message.lastLoginTimestamp;
            if (message.userTokenId != null && message.hasOwnProperty("userTokenId"))
                if (typeof message.userTokenId === "number")
                    object.userTokenId = options.longs === String ? String(message.userTokenId) : message.userTokenId;
                else
                    object.userTokenId = options.longs === String ? $util.Long.prototype.toString.call(message.userTokenId) : options.longs === Number ? new $util.LongBits(message.userTokenId.low >>> 0, message.userTokenId.high >>> 0).toNumber(true) : message.userTokenId;
            return object;
        };

        /**
         * Converts this User to JSON.
         * @function toJSON
         * @memberof user.User
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        User.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for User
         * @function getTypeUrl
         * @memberof user.User
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        User.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/user.User";
        };

        return User;
    })();

    /**
     * UserRole enum.
     * @name user.UserRole
     * @enum {number}
     * @property {number} UNKNOWN=0 UNKNOWN value
     * @property {number} USER=1 USER value
     * @property {number} ADMIN=2 ADMIN value
     * @property {number} MODERATOR=3 MODERATOR value
     */
    user.UserRole = (function() {
        const valuesById = {}, values = Object.create(valuesById);
        values[valuesById[0] = "UNKNOWN"] = 0;
        values[valuesById[1] = "USER"] = 1;
        values[valuesById[2] = "ADMIN"] = 2;
        values[valuesById[3] = "MODERATOR"] = 3;
        return values;
    })();

    user.UserListRequest = (function() {

        /**
         * Properties of a UserListRequest.
         * @memberof user
         * @interface IUserListRequest
         * @property {number|null} [page] UserListRequest page
         * @property {number|null} [pageSize] UserListRequest pageSize
         * @property {string|null} [search] UserListRequest search
         */

        /**
         * Constructs a new UserListRequest.
         * @memberof user
         * @classdesc Represents a UserListRequest.
         * @implements IUserListRequest
         * @constructor
         * @param {user.IUserListRequest=} [properties] Properties to set
         */
        function UserListRequest(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * UserListRequest page.
         * @member {number} page
         * @memberof user.UserListRequest
         * @instance
         */
        UserListRequest.prototype.page = 0;

        /**
         * UserListRequest pageSize.
         * @member {number} pageSize
         * @memberof user.UserListRequest
         * @instance
         */
        UserListRequest.prototype.pageSize = 0;

        /**
         * UserListRequest search.
         * @member {string} search
         * @memberof user.UserListRequest
         * @instance
         */
        UserListRequest.prototype.search = "";

        /**
         * Creates a new UserListRequest instance using the specified properties.
         * @function create
         * @memberof user.UserListRequest
         * @static
         * @param {user.IUserListRequest=} [properties] Properties to set
         * @returns {user.UserListRequest} UserListRequest instance
         */
        UserListRequest.create = function create(properties) {
            return new UserListRequest(properties);
        };

        /**
         * Encodes the specified UserListRequest message. Does not implicitly {@link user.UserListRequest.verify|verify} messages.
         * @function encode
         * @memberof user.UserListRequest
         * @static
         * @param {user.IUserListRequest} message UserListRequest message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        UserListRequest.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.page != null && Object.hasOwnProperty.call(message, "page"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.page);
            if (message.pageSize != null && Object.hasOwnProperty.call(message, "pageSize"))
                writer.uint32(/* id 2, wireType 0 =*/16).int32(message.pageSize);
            if (message.search != null && Object.hasOwnProperty.call(message, "search"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.search);
            return writer;
        };

        /**
         * Encodes the specified UserListRequest message, length delimited. Does not implicitly {@link user.UserListRequest.verify|verify} messages.
         * @function encodeDelimited
         * @memberof user.UserListRequest
         * @static
         * @param {user.IUserListRequest} message UserListRequest message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        UserListRequest.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a UserListRequest message from the specified reader or buffer.
         * @function decode
         * @memberof user.UserListRequest
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {user.UserListRequest} UserListRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        UserListRequest.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.user.UserListRequest();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.page = reader.int32();
                        break;
                    }
                case 2: {
                        message.pageSize = reader.int32();
                        break;
                    }
                case 3: {
                        message.search = reader.string();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a UserListRequest message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof user.UserListRequest
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {user.UserListRequest} UserListRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        UserListRequest.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a UserListRequest message.
         * @function verify
         * @memberof user.UserListRequest
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        UserListRequest.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.page != null && message.hasOwnProperty("page"))
                if (!$util.isInteger(message.page))
                    return "page: integer expected";
            if (message.pageSize != null && message.hasOwnProperty("pageSize"))
                if (!$util.isInteger(message.pageSize))
                    return "pageSize: integer expected";
            if (message.search != null && message.hasOwnProperty("search"))
                if (!$util.isString(message.search))
                    return "search: string expected";
            return null;
        };

        /**
         * Creates a UserListRequest message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof user.UserListRequest
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {user.UserListRequest} UserListRequest
         */
        UserListRequest.fromObject = function fromObject(object) {
            if (object instanceof $root.user.UserListRequest)
                return object;
            let message = new $root.user.UserListRequest();
            if (object.page != null)
                message.page = object.page | 0;
            if (object.pageSize != null)
                message.pageSize = object.pageSize | 0;
            if (object.search != null)
                message.search = String(object.search);
            return message;
        };

        /**
         * Creates a plain object from a UserListRequest message. Also converts values to other types if specified.
         * @function toObject
         * @memberof user.UserListRequest
         * @static
         * @param {user.UserListRequest} message UserListRequest
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        UserListRequest.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.page = 0;
                object.pageSize = 0;
                object.search = "";
            }
            if (message.page != null && message.hasOwnProperty("page"))
                object.page = message.page;
            if (message.pageSize != null && message.hasOwnProperty("pageSize"))
                object.pageSize = message.pageSize;
            if (message.search != null && message.hasOwnProperty("search"))
                object.search = message.search;
            return object;
        };

        /**
         * Converts this UserListRequest to JSON.
         * @function toJSON
         * @memberof user.UserListRequest
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        UserListRequest.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for UserListRequest
         * @function getTypeUrl
         * @memberof user.UserListRequest
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        UserListRequest.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/user.UserListRequest";
        };

        return UserListRequest;
    })();

    user.UserListResponse = (function() {

        /**
         * Properties of a UserListResponse.
         * @memberof user
         * @interface IUserListResponse
         * @property {Array.<user.IUser>|null} [users] UserListResponse users
         * @property {number|null} [total] UserListResponse total
         * @property {number|null} [page] UserListResponse page
         * @property {number|null} [pageSize] UserListResponse pageSize
         */

        /**
         * Constructs a new UserListResponse.
         * @memberof user
         * @classdesc Represents a UserListResponse.
         * @implements IUserListResponse
         * @constructor
         * @param {user.IUserListResponse=} [properties] Properties to set
         */
        function UserListResponse(properties) {
            this.users = [];
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * UserListResponse users.
         * @member {Array.<user.IUser>} users
         * @memberof user.UserListResponse
         * @instance
         */
        UserListResponse.prototype.users = $util.emptyArray;

        /**
         * UserListResponse total.
         * @member {number} total
         * @memberof user.UserListResponse
         * @instance
         */
        UserListResponse.prototype.total = 0;

        /**
         * UserListResponse page.
         * @member {number} page
         * @memberof user.UserListResponse
         * @instance
         */
        UserListResponse.prototype.page = 0;

        /**
         * UserListResponse pageSize.
         * @member {number} pageSize
         * @memberof user.UserListResponse
         * @instance
         */
        UserListResponse.prototype.pageSize = 0;

        /**
         * Creates a new UserListResponse instance using the specified properties.
         * @function create
         * @memberof user.UserListResponse
         * @static
         * @param {user.IUserListResponse=} [properties] Properties to set
         * @returns {user.UserListResponse} UserListResponse instance
         */
        UserListResponse.create = function create(properties) {
            return new UserListResponse(properties);
        };

        /**
         * Encodes the specified UserListResponse message. Does not implicitly {@link user.UserListResponse.verify|verify} messages.
         * @function encode
         * @memberof user.UserListResponse
         * @static
         * @param {user.IUserListResponse} message UserListResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        UserListResponse.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.users != null && message.users.length)
                for (let i = 0; i < message.users.length; ++i)
                    $root.user.User.encode(message.users[i], writer.uint32(/* id 1, wireType 2 =*/10).fork()).ldelim();
            if (message.total != null && Object.hasOwnProperty.call(message, "total"))
                writer.uint32(/* id 2, wireType 0 =*/16).int32(message.total);
            if (message.page != null && Object.hasOwnProperty.call(message, "page"))
                writer.uint32(/* id 3, wireType 0 =*/24).int32(message.page);
            if (message.pageSize != null && Object.hasOwnProperty.call(message, "pageSize"))
                writer.uint32(/* id 4, wireType 0 =*/32).int32(message.pageSize);
            return writer;
        };

        /**
         * Encodes the specified UserListResponse message, length delimited. Does not implicitly {@link user.UserListResponse.verify|verify} messages.
         * @function encodeDelimited
         * @memberof user.UserListResponse
         * @static
         * @param {user.IUserListResponse} message UserListResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        UserListResponse.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a UserListResponse message from the specified reader or buffer.
         * @function decode
         * @memberof user.UserListResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {user.UserListResponse} UserListResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        UserListResponse.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.user.UserListResponse();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        if (!(message.users && message.users.length))
                            message.users = [];
                        message.users.push($root.user.User.decode(reader, reader.uint32()));
                        break;
                    }
                case 2: {
                        message.total = reader.int32();
                        break;
                    }
                case 3: {
                        message.page = reader.int32();
                        break;
                    }
                case 4: {
                        message.pageSize = reader.int32();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a UserListResponse message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof user.UserListResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {user.UserListResponse} UserListResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        UserListResponse.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a UserListResponse message.
         * @function verify
         * @memberof user.UserListResponse
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        UserListResponse.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.users != null && message.hasOwnProperty("users")) {
                if (!Array.isArray(message.users))
                    return "users: array expected";
                for (let i = 0; i < message.users.length; ++i) {
                    let error = $root.user.User.verify(message.users[i]);
                    if (error)
                        return "users." + error;
                }
            }
            if (message.total != null && message.hasOwnProperty("total"))
                if (!$util.isInteger(message.total))
                    return "total: integer expected";
            if (message.page != null && message.hasOwnProperty("page"))
                if (!$util.isInteger(message.page))
                    return "page: integer expected";
            if (message.pageSize != null && message.hasOwnProperty("pageSize"))
                if (!$util.isInteger(message.pageSize))
                    return "pageSize: integer expected";
            return null;
        };

        /**
         * Creates a UserListResponse message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof user.UserListResponse
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {user.UserListResponse} UserListResponse
         */
        UserListResponse.fromObject = function fromObject(object) {
            if (object instanceof $root.user.UserListResponse)
                return object;
            let message = new $root.user.UserListResponse();
            if (object.users) {
                if (!Array.isArray(object.users))
                    throw TypeError(".user.UserListResponse.users: array expected");
                message.users = [];
                for (let i = 0; i < object.users.length; ++i) {
                    if (typeof object.users[i] !== "object")
                        throw TypeError(".user.UserListResponse.users: object expected");
                    message.users[i] = $root.user.User.fromObject(object.users[i]);
                }
            }
            if (object.total != null)
                message.total = object.total | 0;
            if (object.page != null)
                message.page = object.page | 0;
            if (object.pageSize != null)
                message.pageSize = object.pageSize | 0;
            return message;
        };

        /**
         * Creates a plain object from a UserListResponse message. Also converts values to other types if specified.
         * @function toObject
         * @memberof user.UserListResponse
         * @static
         * @param {user.UserListResponse} message UserListResponse
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        UserListResponse.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.arrays || options.defaults)
                object.users = [];
            if (options.defaults) {
                object.total = 0;
                object.page = 0;
                object.pageSize = 0;
            }
            if (message.users && message.users.length) {
                object.users = [];
                for (let j = 0; j < message.users.length; ++j)
                    object.users[j] = $root.user.User.toObject(message.users[j], options);
            }
            if (message.total != null && message.hasOwnProperty("total"))
                object.total = message.total;
            if (message.page != null && message.hasOwnProperty("page"))
                object.page = message.page;
            if (message.pageSize != null && message.hasOwnProperty("pageSize"))
                object.pageSize = message.pageSize;
            return object;
        };

        /**
         * Converts this UserListResponse to JSON.
         * @function toJSON
         * @memberof user.UserListResponse
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        UserListResponse.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for UserListResponse
         * @function getTypeUrl
         * @memberof user.UserListResponse
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        UserListResponse.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/user.UserListResponse";
        };

        return UserListResponse;
    })();

    user.CreateUserRequest = (function() {

        /**
         * Properties of a CreateUserRequest.
         * @memberof user
         * @interface ICreateUserRequest
         * @property {string|null} [name] CreateUserRequest name
         * @property {string|null} [email] CreateUserRequest email
         * @property {number|null} [age] CreateUserRequest age
         * @property {user.UserRole|null} [role] CreateUserRequest role
         * @property {Array.<string>|null} [tags] CreateUserRequest tags
         */

        /**
         * Constructs a new CreateUserRequest.
         * @memberof user
         * @classdesc Represents a CreateUserRequest.
         * @implements ICreateUserRequest
         * @constructor
         * @param {user.ICreateUserRequest=} [properties] Properties to set
         */
        function CreateUserRequest(properties) {
            this.tags = [];
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * CreateUserRequest name.
         * @member {string} name
         * @memberof user.CreateUserRequest
         * @instance
         */
        CreateUserRequest.prototype.name = "";

        /**
         * CreateUserRequest email.
         * @member {string} email
         * @memberof user.CreateUserRequest
         * @instance
         */
        CreateUserRequest.prototype.email = "";

        /**
         * CreateUserRequest age.
         * @member {number} age
         * @memberof user.CreateUserRequest
         * @instance
         */
        CreateUserRequest.prototype.age = 0;

        /**
         * CreateUserRequest role.
         * @member {user.UserRole} role
         * @memberof user.CreateUserRequest
         * @instance
         */
        CreateUserRequest.prototype.role = 0;

        /**
         * CreateUserRequest tags.
         * @member {Array.<string>} tags
         * @memberof user.CreateUserRequest
         * @instance
         */
        CreateUserRequest.prototype.tags = $util.emptyArray;

        /**
         * Creates a new CreateUserRequest instance using the specified properties.
         * @function create
         * @memberof user.CreateUserRequest
         * @static
         * @param {user.ICreateUserRequest=} [properties] Properties to set
         * @returns {user.CreateUserRequest} CreateUserRequest instance
         */
        CreateUserRequest.create = function create(properties) {
            return new CreateUserRequest(properties);
        };

        /**
         * Encodes the specified CreateUserRequest message. Does not implicitly {@link user.CreateUserRequest.verify|verify} messages.
         * @function encode
         * @memberof user.CreateUserRequest
         * @static
         * @param {user.ICreateUserRequest} message CreateUserRequest message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        CreateUserRequest.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.name != null && Object.hasOwnProperty.call(message, "name"))
                writer.uint32(/* id 1, wireType 2 =*/10).string(message.name);
            if (message.email != null && Object.hasOwnProperty.call(message, "email"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.email);
            if (message.age != null && Object.hasOwnProperty.call(message, "age"))
                writer.uint32(/* id 3, wireType 0 =*/24).int32(message.age);
            if (message.role != null && Object.hasOwnProperty.call(message, "role"))
                writer.uint32(/* id 4, wireType 0 =*/32).int32(message.role);
            if (message.tags != null && message.tags.length)
                for (let i = 0; i < message.tags.length; ++i)
                    writer.uint32(/* id 5, wireType 2 =*/42).string(message.tags[i]);
            return writer;
        };

        /**
         * Encodes the specified CreateUserRequest message, length delimited. Does not implicitly {@link user.CreateUserRequest.verify|verify} messages.
         * @function encodeDelimited
         * @memberof user.CreateUserRequest
         * @static
         * @param {user.ICreateUserRequest} message CreateUserRequest message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        CreateUserRequest.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a CreateUserRequest message from the specified reader or buffer.
         * @function decode
         * @memberof user.CreateUserRequest
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {user.CreateUserRequest} CreateUserRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        CreateUserRequest.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.user.CreateUserRequest();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.name = reader.string();
                        break;
                    }
                case 2: {
                        message.email = reader.string();
                        break;
                    }
                case 3: {
                        message.age = reader.int32();
                        break;
                    }
                case 4: {
                        message.role = reader.int32();
                        break;
                    }
                case 5: {
                        if (!(message.tags && message.tags.length))
                            message.tags = [];
                        message.tags.push(reader.string());
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a CreateUserRequest message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof user.CreateUserRequest
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {user.CreateUserRequest} CreateUserRequest
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        CreateUserRequest.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a CreateUserRequest message.
         * @function verify
         * @memberof user.CreateUserRequest
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        CreateUserRequest.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.name != null && message.hasOwnProperty("name"))
                if (!$util.isString(message.name))
                    return "name: string expected";
            if (message.email != null && message.hasOwnProperty("email"))
                if (!$util.isString(message.email))
                    return "email: string expected";
            if (message.age != null && message.hasOwnProperty("age"))
                if (!$util.isInteger(message.age))
                    return "age: integer expected";
            if (message.role != null && message.hasOwnProperty("role"))
                switch (message.role) {
                default:
                    return "role: enum value expected";
                case 0:
                case 1:
                case 2:
                case 3:
                    break;
                }
            if (message.tags != null && message.hasOwnProperty("tags")) {
                if (!Array.isArray(message.tags))
                    return "tags: array expected";
                for (let i = 0; i < message.tags.length; ++i)
                    if (!$util.isString(message.tags[i]))
                        return "tags: string[] expected";
            }
            return null;
        };

        /**
         * Creates a CreateUserRequest message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof user.CreateUserRequest
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {user.CreateUserRequest} CreateUserRequest
         */
        CreateUserRequest.fromObject = function fromObject(object) {
            if (object instanceof $root.user.CreateUserRequest)
                return object;
            let message = new $root.user.CreateUserRequest();
            if (object.name != null)
                message.name = String(object.name);
            if (object.email != null)
                message.email = String(object.email);
            if (object.age != null)
                message.age = object.age | 0;
            switch (object.role) {
            default:
                if (typeof object.role === "number") {
                    message.role = object.role;
                    break;
                }
                break;
            case "UNKNOWN":
            case 0:
                message.role = 0;
                break;
            case "USER":
            case 1:
                message.role = 1;
                break;
            case "ADMIN":
            case 2:
                message.role = 2;
                break;
            case "MODERATOR":
            case 3:
                message.role = 3;
                break;
            }
            if (object.tags) {
                if (!Array.isArray(object.tags))
                    throw TypeError(".user.CreateUserRequest.tags: array expected");
                message.tags = [];
                for (let i = 0; i < object.tags.length; ++i)
                    message.tags[i] = String(object.tags[i]);
            }
            return message;
        };

        /**
         * Creates a plain object from a CreateUserRequest message. Also converts values to other types if specified.
         * @function toObject
         * @memberof user.CreateUserRequest
         * @static
         * @param {user.CreateUserRequest} message CreateUserRequest
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        CreateUserRequest.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.arrays || options.defaults)
                object.tags = [];
            if (options.defaults) {
                object.name = "";
                object.email = "";
                object.age = 0;
                object.role = options.enums === String ? "UNKNOWN" : 0;
            }
            if (message.name != null && message.hasOwnProperty("name"))
                object.name = message.name;
            if (message.email != null && message.hasOwnProperty("email"))
                object.email = message.email;
            if (message.age != null && message.hasOwnProperty("age"))
                object.age = message.age;
            if (message.role != null && message.hasOwnProperty("role"))
                object.role = options.enums === String ? $root.user.UserRole[message.role] === undefined ? message.role : $root.user.UserRole[message.role] : message.role;
            if (message.tags && message.tags.length) {
                object.tags = [];
                for (let j = 0; j < message.tags.length; ++j)
                    object.tags[j] = message.tags[j];
            }
            return object;
        };

        /**
         * Converts this CreateUserRequest to JSON.
         * @function toJSON
         * @memberof user.CreateUserRequest
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        CreateUserRequest.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for CreateUserRequest
         * @function getTypeUrl
         * @memberof user.CreateUserRequest
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        CreateUserRequest.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/user.CreateUserRequest";
        };

        return CreateUserRequest;
    })();

    user.CommonResponse = (function() {

        /**
         * Properties of a CommonResponse.
         * @memberof user
         * @interface ICommonResponse
         * @property {boolean|null} [success] CommonResponse success
         * @property {string|null} [message] CommonResponse message
         * @property {number|null} [code] CommonResponse code
         */

        /**
         * Constructs a new CommonResponse.
         * @memberof user
         * @classdesc Represents a CommonResponse.
         * @implements ICommonResponse
         * @constructor
         * @param {user.ICommonResponse=} [properties] Properties to set
         */
        function CommonResponse(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * CommonResponse success.
         * @member {boolean} success
         * @memberof user.CommonResponse
         * @instance
         */
        CommonResponse.prototype.success = false;

        /**
         * CommonResponse message.
         * @member {string} message
         * @memberof user.CommonResponse
         * @instance
         */
        CommonResponse.prototype.message = "";

        /**
         * CommonResponse code.
         * @member {number} code
         * @memberof user.CommonResponse
         * @instance
         */
        CommonResponse.prototype.code = 0;

        /**
         * Creates a new CommonResponse instance using the specified properties.
         * @function create
         * @memberof user.CommonResponse
         * @static
         * @param {user.ICommonResponse=} [properties] Properties to set
         * @returns {user.CommonResponse} CommonResponse instance
         */
        CommonResponse.create = function create(properties) {
            return new CommonResponse(properties);
        };

        /**
         * Encodes the specified CommonResponse message. Does not implicitly {@link user.CommonResponse.verify|verify} messages.
         * @function encode
         * @memberof user.CommonResponse
         * @static
         * @param {user.ICommonResponse} message CommonResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        CommonResponse.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.success != null && Object.hasOwnProperty.call(message, "success"))
                writer.uint32(/* id 1, wireType 0 =*/8).bool(message.success);
            if (message.message != null && Object.hasOwnProperty.call(message, "message"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.message);
            if (message.code != null && Object.hasOwnProperty.call(message, "code"))
                writer.uint32(/* id 3, wireType 0 =*/24).int32(message.code);
            return writer;
        };

        /**
         * Encodes the specified CommonResponse message, length delimited. Does not implicitly {@link user.CommonResponse.verify|verify} messages.
         * @function encodeDelimited
         * @memberof user.CommonResponse
         * @static
         * @param {user.ICommonResponse} message CommonResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        CommonResponse.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a CommonResponse message from the specified reader or buffer.
         * @function decode
         * @memberof user.CommonResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {user.CommonResponse} CommonResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        CommonResponse.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.user.CommonResponse();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.success = reader.bool();
                        break;
                    }
                case 2: {
                        message.message = reader.string();
                        break;
                    }
                case 3: {
                        message.code = reader.int32();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a CommonResponse message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof user.CommonResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {user.CommonResponse} CommonResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        CommonResponse.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a CommonResponse message.
         * @function verify
         * @memberof user.CommonResponse
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        CommonResponse.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.success != null && message.hasOwnProperty("success"))
                if (typeof message.success !== "boolean")
                    return "success: boolean expected";
            if (message.message != null && message.hasOwnProperty("message"))
                if (!$util.isString(message.message))
                    return "message: string expected";
            if (message.code != null && message.hasOwnProperty("code"))
                if (!$util.isInteger(message.code))
                    return "code: integer expected";
            return null;
        };

        /**
         * Creates a CommonResponse message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof user.CommonResponse
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {user.CommonResponse} CommonResponse
         */
        CommonResponse.fromObject = function fromObject(object) {
            if (object instanceof $root.user.CommonResponse)
                return object;
            let message = new $root.user.CommonResponse();
            if (object.success != null)
                message.success = Boolean(object.success);
            if (object.message != null)
                message.message = String(object.message);
            if (object.code != null)
                message.code = object.code | 0;
            return message;
        };

        /**
         * Creates a plain object from a CommonResponse message. Also converts values to other types if specified.
         * @function toObject
         * @memberof user.CommonResponse
         * @static
         * @param {user.CommonResponse} message CommonResponse
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        CommonResponse.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.success = false;
                object.message = "";
                object.code = 0;
            }
            if (message.success != null && message.hasOwnProperty("success"))
                object.success = message.success;
            if (message.message != null && message.hasOwnProperty("message"))
                object.message = message.message;
            if (message.code != null && message.hasOwnProperty("code"))
                object.code = message.code;
            return object;
        };

        /**
         * Converts this CommonResponse to JSON.
         * @function toJSON
         * @memberof user.CommonResponse
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        CommonResponse.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for CommonResponse
         * @function getTypeUrl
         * @memberof user.CommonResponse
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        CommonResponse.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/user.CommonResponse";
        };

        return CommonResponse;
    })();

    user.LongTestMessage = (function() {

        /**
         * Properties of a LongTestMessage.
         * @memberof user
         * @interface ILongTestMessage
         * @property {number|Long|null} [signedLong] LongTestMessage signedLong
         * @property {number|Long|null} [unsignedLong] LongTestMessage unsignedLong
         * @property {Array.<number|Long>|null} [longArray] LongTestMessage longArray
         */

        /**
         * Constructs a new LongTestMessage.
         * @memberof user
         * @classdesc Represents a LongTestMessage.
         * @implements ILongTestMessage
         * @constructor
         * @param {user.ILongTestMessage=} [properties] Properties to set
         */
        function LongTestMessage(properties) {
            this.longArray = [];
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * LongTestMessage signedLong.
         * @member {number|Long} signedLong
         * @memberof user.LongTestMessage
         * @instance
         */
        LongTestMessage.prototype.signedLong = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * LongTestMessage unsignedLong.
         * @member {number|Long} unsignedLong
         * @memberof user.LongTestMessage
         * @instance
         */
        LongTestMessage.prototype.unsignedLong = $util.Long ? $util.Long.fromBits(0,0,true) : 0;

        /**
         * LongTestMessage longArray.
         * @member {Array.<number|Long>} longArray
         * @memberof user.LongTestMessage
         * @instance
         */
        LongTestMessage.prototype.longArray = $util.emptyArray;

        /**
         * Creates a new LongTestMessage instance using the specified properties.
         * @function create
         * @memberof user.LongTestMessage
         * @static
         * @param {user.ILongTestMessage=} [properties] Properties to set
         * @returns {user.LongTestMessage} LongTestMessage instance
         */
        LongTestMessage.create = function create(properties) {
            return new LongTestMessage(properties);
        };

        /**
         * Encodes the specified LongTestMessage message. Does not implicitly {@link user.LongTestMessage.verify|verify} messages.
         * @function encode
         * @memberof user.LongTestMessage
         * @static
         * @param {user.ILongTestMessage} message LongTestMessage message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        LongTestMessage.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.signedLong != null && Object.hasOwnProperty.call(message, "signedLong"))
                writer.uint32(/* id 1, wireType 0 =*/8).int64(message.signedLong);
            if (message.unsignedLong != null && Object.hasOwnProperty.call(message, "unsignedLong"))
                writer.uint32(/* id 2, wireType 0 =*/16).uint64(message.unsignedLong);
            if (message.longArray != null && message.longArray.length) {
                writer.uint32(/* id 3, wireType 2 =*/26).fork();
                for (let i = 0; i < message.longArray.length; ++i)
                    writer.int64(message.longArray[i]);
                writer.ldelim();
            }
            return writer;
        };

        /**
         * Encodes the specified LongTestMessage message, length delimited. Does not implicitly {@link user.LongTestMessage.verify|verify} messages.
         * @function encodeDelimited
         * @memberof user.LongTestMessage
         * @static
         * @param {user.ILongTestMessage} message LongTestMessage message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        LongTestMessage.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a LongTestMessage message from the specified reader or buffer.
         * @function decode
         * @memberof user.LongTestMessage
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {user.LongTestMessage} LongTestMessage
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        LongTestMessage.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.user.LongTestMessage();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.signedLong = reader.int64();
                        break;
                    }
                case 2: {
                        message.unsignedLong = reader.uint64();
                        break;
                    }
                case 3: {
                        if (!(message.longArray && message.longArray.length))
                            message.longArray = [];
                        if ((tag & 7) === 2) {
                            let end2 = reader.uint32() + reader.pos;
                            while (reader.pos < end2)
                                message.longArray.push(reader.int64());
                        } else
                            message.longArray.push(reader.int64());
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a LongTestMessage message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof user.LongTestMessage
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {user.LongTestMessage} LongTestMessage
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        LongTestMessage.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a LongTestMessage message.
         * @function verify
         * @memberof user.LongTestMessage
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        LongTestMessage.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.signedLong != null && message.hasOwnProperty("signedLong"))
                if (!$util.isInteger(message.signedLong) && !(message.signedLong && $util.isInteger(message.signedLong.low) && $util.isInteger(message.signedLong.high)))
                    return "signedLong: integer|Long expected";
            if (message.unsignedLong != null && message.hasOwnProperty("unsignedLong"))
                if (!$util.isInteger(message.unsignedLong) && !(message.unsignedLong && $util.isInteger(message.unsignedLong.low) && $util.isInteger(message.unsignedLong.high)))
                    return "unsignedLong: integer|Long expected";
            if (message.longArray != null && message.hasOwnProperty("longArray")) {
                if (!Array.isArray(message.longArray))
                    return "longArray: array expected";
                for (let i = 0; i < message.longArray.length; ++i)
                    if (!$util.isInteger(message.longArray[i]) && !(message.longArray[i] && $util.isInteger(message.longArray[i].low) && $util.isInteger(message.longArray[i].high)))
                        return "longArray: integer|Long[] expected";
            }
            return null;
        };

        /**
         * Creates a LongTestMessage message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof user.LongTestMessage
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {user.LongTestMessage} LongTestMessage
         */
        LongTestMessage.fromObject = function fromObject(object) {
            if (object instanceof $root.user.LongTestMessage)
                return object;
            let message = new $root.user.LongTestMessage();
            if (object.signedLong != null)
                if ($util.Long)
                    (message.signedLong = $util.Long.fromValue(object.signedLong)).unsigned = false;
                else if (typeof object.signedLong === "string")
                    message.signedLong = parseInt(object.signedLong, 10);
                else if (typeof object.signedLong === "number")
                    message.signedLong = object.signedLong;
                else if (typeof object.signedLong === "object")
                    message.signedLong = new $util.LongBits(object.signedLong.low >>> 0, object.signedLong.high >>> 0).toNumber();
            if (object.unsignedLong != null)
                if ($util.Long)
                    (message.unsignedLong = $util.Long.fromValue(object.unsignedLong)).unsigned = true;
                else if (typeof object.unsignedLong === "string")
                    message.unsignedLong = parseInt(object.unsignedLong, 10);
                else if (typeof object.unsignedLong === "number")
                    message.unsignedLong = object.unsignedLong;
                else if (typeof object.unsignedLong === "object")
                    message.unsignedLong = new $util.LongBits(object.unsignedLong.low >>> 0, object.unsignedLong.high >>> 0).toNumber(true);
            if (object.longArray) {
                if (!Array.isArray(object.longArray))
                    throw TypeError(".user.LongTestMessage.longArray: array expected");
                message.longArray = [];
                for (let i = 0; i < object.longArray.length; ++i)
                    if ($util.Long)
                        (message.longArray[i] = $util.Long.fromValue(object.longArray[i])).unsigned = false;
                    else if (typeof object.longArray[i] === "string")
                        message.longArray[i] = parseInt(object.longArray[i], 10);
                    else if (typeof object.longArray[i] === "number")
                        message.longArray[i] = object.longArray[i];
                    else if (typeof object.longArray[i] === "object")
                        message.longArray[i] = new $util.LongBits(object.longArray[i].low >>> 0, object.longArray[i].high >>> 0).toNumber();
            }
            return message;
        };

        /**
         * Creates a plain object from a LongTestMessage message. Also converts values to other types if specified.
         * @function toObject
         * @memberof user.LongTestMessage
         * @static
         * @param {user.LongTestMessage} message LongTestMessage
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        LongTestMessage.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.arrays || options.defaults)
                object.longArray = [];
            if (options.defaults) {
                if ($util.Long) {
                    let long = new $util.Long(0, 0, false);
                    object.signedLong = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.signedLong = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    let long = new $util.Long(0, 0, true);
                    object.unsignedLong = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.unsignedLong = options.longs === String ? "0" : 0;
            }
            if (message.signedLong != null && message.hasOwnProperty("signedLong"))
                if (typeof message.signedLong === "number")
                    object.signedLong = options.longs === String ? String(message.signedLong) : message.signedLong;
                else
                    object.signedLong = options.longs === String ? $util.Long.prototype.toString.call(message.signedLong) : options.longs === Number ? new $util.LongBits(message.signedLong.low >>> 0, message.signedLong.high >>> 0).toNumber() : message.signedLong;
            if (message.unsignedLong != null && message.hasOwnProperty("unsignedLong"))
                if (typeof message.unsignedLong === "number")
                    object.unsignedLong = options.longs === String ? String(message.unsignedLong) : message.unsignedLong;
                else
                    object.unsignedLong = options.longs === String ? $util.Long.prototype.toString.call(message.unsignedLong) : options.longs === Number ? new $util.LongBits(message.unsignedLong.low >>> 0, message.unsignedLong.high >>> 0).toNumber(true) : message.unsignedLong;
            if (message.longArray && message.longArray.length) {
                object.longArray = [];
                for (let j = 0; j < message.longArray.length; ++j)
                    if (typeof message.longArray[j] === "number")
                        object.longArray[j] = options.longs === String ? String(message.longArray[j]) : message.longArray[j];
                    else
                        object.longArray[j] = options.longs === String ? $util.Long.prototype.toString.call(message.longArray[j]) : options.longs === Number ? new $util.LongBits(message.longArray[j].low >>> 0, message.longArray[j].high >>> 0).toNumber() : message.longArray[j];
            }
            return object;
        };

        /**
         * Converts this LongTestMessage to JSON.
         * @function toJSON
         * @memberof user.LongTestMessage
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        LongTestMessage.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for LongTestMessage
         * @function getTypeUrl
         * @memberof user.LongTestMessage
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        LongTestMessage.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/user.LongTestMessage";
        };

        return LongTestMessage;
    })();

    return user;
})();

export { $root as default };
