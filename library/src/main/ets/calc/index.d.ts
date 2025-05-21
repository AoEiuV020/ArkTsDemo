export function add(a: number, b: number): number;

export function decrease(a: number): number;

export function decrease2(a: number): number;

// 让 TypeScript 知道这些属性存在于 globalThis 上
declare global {
  var minus: (a: number, b: number) => number;
}
