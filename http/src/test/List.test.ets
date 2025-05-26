import httpTest from './http.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  httpTest();
}