import { HarmonyTcpSocketFactory } from 'socket';
import util from '@ohos.util';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
          socketTest();
        })
    }
    .height('100%')
    .width('100%')
  }
}

async function socketTest(): Promise<void> {
  console.log('socketTest');
  let tcpSocket = HarmonyTcpSocketFactory.createSocket();
  await tcpSocket.connect({
    address: '192.168.0.66',
    port: 8888,
    timeout: 2000
  });

  console.log('✅ 成功连接到8888端口');

  // 如果连接成功，发送测试消息并等待回显
  const testMessage = 'Hello Server!';
  const messageBytes = new util.TextEncoder().encode(testMessage);

  // 创建Promise等待回显数据
  const echoPromise = new Promise<string>((resolve, reject) => {
    const timeout = setTimeout(() => {
      reject(new Error('等待回显超时'));
    }, 3000);

    tcpSocket.on('message', (data: Uint8Array) => {
      clearTimeout(timeout);
      const echoText = new util.TextDecoder().decode(data);
      console.log('📨 收到回显数据:', echoText);
      resolve(echoText);
    });
  });

  await tcpSocket.send(messageBytes);
  console.log('📤 发送消息:', testMessage);

  const echoText = await echoPromise;
  console.log('✅ 收到回显:', echoText);

  await tcpSocket.close();

}