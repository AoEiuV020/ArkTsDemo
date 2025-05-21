/* eslint-disable no-var */

// 让 TypeScript 知道这些属性存在于 globalThis 上
declare global {
  var minus: (a: number, b: number) => number;
}

export { };
