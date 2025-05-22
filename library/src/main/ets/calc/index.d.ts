import { Counter } from 'library1/src/main/ets/counter/counter';

// 导出 Calc 变量
export const Calc: {
  Counter: typeof Counter;
  minus: (a: number, b: number) => number;
  add: (a: number, b: number) => number;
  increase: (a: number) => number;
  decrease: (a: number) => number;
  decrease2: (a: number) => number;
};
