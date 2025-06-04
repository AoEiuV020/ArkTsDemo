import harmonyTcpSocketFactoryTest from './HarmonyTcpSocketFactory.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  harmonyTcpSocketFactoryTest();
}