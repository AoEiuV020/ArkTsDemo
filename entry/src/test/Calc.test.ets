import { describe, it } from '@ohos/hypium';
import { add, decrease, decrease2, minus } from 'library';

export default function calcTest() {
  describe('calcTest', () => {
    it('add', 0, () => {
      const result = add(1, 2);
      console.log(result.toString());
    });
    it('minus', 0, () => {
      const result = minus(1, 2);
      console.log(result.toString());
    });
    it('decrease', 0, () => {
      const result = decrease(1);
      console.log(result.toString());
    });
    it('decrease2', 0, () => {
      const result = decrease2(1);
      console.log(result.toString());
    });
  });
}