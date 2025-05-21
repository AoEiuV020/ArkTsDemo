// 创建 Calc 对象
export const Calc = {
  // 这些方法会在各自的文件中被实现和绑定
  minus: undefined,
  add: undefined,
  decrease: undefined,
  decrease2: undefined
};

// 导入 add 函数的实现
import { add } from './add';
// 导入 decrease 函数的实现
import { decrease } from './decrease';
// 导入 decrease2 函数的实现
import { decrease2 } from './decrease2';

// 将所有实现绑定到 Calc 对象
Calc.add = add;
Calc.decrease = decrease;
Calc.decrease2 = decrease2;

console.log("Calc initialized:", Calc);