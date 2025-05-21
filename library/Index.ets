import { minus } from './src/main/ets/utils/Minus';

// 警告，但是能用， "globalThis" is not supported (arkts-no-globalthis) <ArkTSCheck>
globalThis.minus = minus;

export { minus }

export { add, decrease, decrease2 } from './src/main/ets/calc';

export { StringUtils } from './src/main/ets/utils/StringUtils';
