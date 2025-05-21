import { minus } from './src/main/ets/utils/Minus';

export { minus }

export { add, decrease } from './src/main/ets/calc';

export { StringUtils } from './src/main/ets/utils/StringUtils';

// 警告，但是能用， "globalThis" is not supported (arkts-no-globalthis) <ArkTSCheck>
globalThis.minus = minus;
