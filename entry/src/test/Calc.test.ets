import { describe, it } from '@ohos/hypium';
import { add } from 'library';

export default function calcTest() {
  describe('calcTest', () => {
    it('add', 0, () => {
      const result = add(1, 2);
      console.log(result.toString());
    });
  });
}