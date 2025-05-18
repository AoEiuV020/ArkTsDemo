import { describe, it } from '@ohos/hypium';
import { add } from 'library';

export default function calcTest() {
  describe('calcTest', () => {
    it('add', 0, () => {
      console.log(add(1, 3).toString());
    });
  });
}