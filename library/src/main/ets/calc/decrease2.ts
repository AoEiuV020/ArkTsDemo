import { Calc } from '.';

// 实现 decrease2 函数
export function decrease2(a: number): number {
  // 这个函数会在 Calc.minus 初始化后被调用
  return Calc.minus(a, 2);
}