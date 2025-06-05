const { NodejsTcpSocketFactory } = require('./src/NodejsTcpSocketFactory');
const { createServer } = require('net');

async function debugTest() {
  console.log('Starting debug test...');

  // 创建测试服务器
  const server = createServer(socket => {
    console.log('Server: Client connected');
    socket.on('data', data => {
      console.log('Server: Received data:', data);
      socket.write(data);
    });
  });

  await new Promise(resolve => {
    server.listen(0, '127.0.0.1', () => {
      const port = server.address().port;
      console.log('Server listening on port:', port);
      resolve();

      // 测试socket
      testSocket(port).finally(() => {
        server.close();
      });
    });
  });
}

async function testSocket(port) {
  console.log('\n--- Testing multiple event listeners ---');

  const socket = NodejsTcpSocketFactory.createSocket();
  const connectCallbacks = [];
  const messageCallbacks = [];

  // 添加多个监听器
  socket.on('connect', () => {
    console.log('Connect callback 1 fired');
    connectCallbacks.push(1);
  });
  socket.on('connect', () => {
    console.log('Connect callback 2 fired');
    connectCallbacks.push(2);
  });
  socket.on('connect', () => {
    console.log('Connect callback 3 fired');
    connectCallbacks.push(3);
  });

  socket.on('message', data => {
    console.log('Message callback 1 fired, data:', data);
    messageCallbacks.push(1);
  });
  socket.on('message', data => {
    console.log('Message callback 2 fired, data:', data);
    messageCallbacks.push(2);
  });

  console.log('Connecting...');
  await socket.connect({
    address: '127.0.0.1',
    port: port,
  });

  console.log('Connected. Connect callbacks:', connectCallbacks);

  console.log('Sending message...');
  await socket.send(new Uint8Array([1, 2, 3]));

  // 等待消息
  await new Promise(resolve => setTimeout(resolve, 100));

  console.log('Message callbacks:', messageCallbacks);

  await socket.close();
  console.log('Socket closed');
}

debugTest().catch(console.error);
