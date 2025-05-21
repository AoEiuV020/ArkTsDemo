import { minus } from './src/main/ets/utils/Minus';
import { Calc } from './src/main/ets/calc';
import { add } from './src/main/ets/calc/add';
import { decrease } from './src/main/ets/calc/decrease';
import { decrease2 } from './src/main/ets/calc/decrease2';

// 统一在这里进行所有函数的绑定
Calc.minus = minus;
Calc.add = add;
Calc.decrease = decrease;
Calc.decrease2 = decrease2;

export { Calc };
export { StringUtils } from './src/main/ets/utils/StringUtils';
