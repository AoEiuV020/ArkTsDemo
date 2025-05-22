import localUnitTest from './LocalUnit.test';
import secureTest from './Secure.test';

export default function testsuite() {
  localUnitTest();
  secureTest();
}