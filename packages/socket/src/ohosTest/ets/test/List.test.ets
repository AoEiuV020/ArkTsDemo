import harmonyTcpSocketFactoryTest from './HarmonyTcpSocketFactory.test';
import abilityTest from './Ability.test';
import harmonyTcpClientTest from './HarmonyTcpClient.test';

export default function testsuite() {
  abilityTest();
  harmonyTcpSocketFactoryTest();
  harmonyTcpClientTest();
}