/**
 * 初始化采集器
 * @param filePath 文件保存路径
 * @returns 是否初始化成功
 */
export function init(filePath: string): boolean;

/**
 * 开始采集
 */
export function start(): void;

/**
 * 停止采集
 */
export function stop(): void;

/**
 * 释放资源
 */
export function release(): void;

/**
 * 获取采集器状态
 * @returns 状态值：-1-未初始化 0-新建 1-已准备 2-运行中 3-已停止 4-已释放 5-已暂停
 */
export function getState(): number;

/**
 * 获取已采集文件大小
 * @returns 文件大小（字节）
 */
export function getFileSize(): number;