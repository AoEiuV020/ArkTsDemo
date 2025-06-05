import harmonyTcpSocketFactoryTest from './HarmonyTcpSocketFactory.test';
import abilityTest from './Ability.test';
import harmonyTcpClientTest from './HarmonyTcpClient.test';
import tcpServerIntegration from './TcpServerIntegration.test';

export default function testsuite() {
  abilityTest();
  harmonyTcpSocketFactoryTest();
  harmonyTcpClientTest();
  tcpServerIntegration();
}