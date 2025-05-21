import { describe, it } from '@ohos/hypium';
import { Calc } from 'library';

export default function calcTest() {
  describe('calcTest', () => {
    it('add', 0, () => {
      const result = Calc.add(1, 2);
      console.log(result.toString());
    });
    it('minus', 0, () => {
      const result = Calc.minus(1, 2);
      console.log(result.toString());
    });
    it('decrease', 0, () => {
      const result = Calc.decrease(1);
      console.log(result.toString());
    });
    it('decrease2', 0, () => {
      const result = Calc.decrease2(1);
      console.log(result.toString());
    });
  });
}