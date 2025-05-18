import calcTest from './Calc.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  calcTest();
}