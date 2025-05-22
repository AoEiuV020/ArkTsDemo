// 导入函数实现
import { add } from './add';
import { increase } from './increase';
import { decrease } from './decrease';
import { decrease2 } from './decrease2';

// 创建空的 Calc 对象
export const Calc = {};

// 逐个函数赋值
Calc.minus = undefined; // 这将在 Index.ets 中被赋值
Calc.add = add;
Calc.increase = increase;
Calc.decrease = decrease;
Calc.decrease2 = decrease2;

console.log("Calc initialized:", Calc);