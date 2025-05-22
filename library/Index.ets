import { minus } from './src/main/ets/utils/Minus';
import { Calc } from './src/main/ets/calc';
import { Counter } from 'library1';

Calc.minus = minus;

// Classes cannot be used as objects (arkts-no-classes-as-obj) <ArkTSCheck>
Calc.Counter = Counter;

export { Calc };
export { StringUtils } from './src/main/ets/utils/StringUtils';
