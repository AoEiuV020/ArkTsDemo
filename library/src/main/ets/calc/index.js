// 导入函数实现
import { add } from './add';
import { decrease } from './decrease';
import { decrease2 } from './decrease2';

// 创建 Calc 对象
export const Calc = {
  minus: undefined, // 这将在 Index.ets 中被赋值
  add,
  decrease,
  decrease2
};

console.log("Calc initialized:", Calc);