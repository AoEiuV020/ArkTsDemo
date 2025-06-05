import harmonyTcpSocketFactoryTest from './HarmonyTcpSocketFactory.test';
import harmonyTcpClientTest from './HarmonyTcpClient.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  harmonyTcpSocketFactoryTest();
  harmonyTcpClientTest();
}