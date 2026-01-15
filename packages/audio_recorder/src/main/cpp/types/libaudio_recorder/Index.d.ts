/**
 * 初始化采集器
 * @param outputFilePath 输出文件路径
 *   - 后缀.pcm: 只产出PCM文件
 *   - 其他后缀: 产出PCM文件 + 编码后文件
 * @returns 是否初始化成功
 */
export function init(outputFilePath: string): boolean;

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
 * 获取已采集PCM文件大小
 * @returns 文件大小（字节）
 */
export function getFileSize(): number;

/**
 * 获取PCM文件路径
 */
export function getPcmFilePath(): string;