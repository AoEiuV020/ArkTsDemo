import jsonRpcTest from './JsonRpc.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  jsonRpcTest();
}