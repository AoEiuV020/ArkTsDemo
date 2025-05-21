// 定义 Calc 接口
export interface CalcInterface {
  minus: (a: number, b: number) => number;
  add: (a: number, b: number) => number;
  decrease: (a: number) => number;
  decrease2: (a: number) => number;
}

// 导出 Calc 变量，实现 CalcInterface 接口
export const Calc: CalcInterface;
