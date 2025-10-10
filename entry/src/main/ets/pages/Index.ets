import { FileInfo, FilePickerUtils } from '../utils/FilePickerUtils';
import { UploadUtils } from '../utils/UploadUtils';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct Index {
  @State serverUrl: string = 'http://192.168.2.45:3001';
  @State uploadPath: string = '/upload';
  @State logs: string[] = [];
  @State isUploading: boolean = false;
  @State currentFileInfo: FileInfo | null = null;

  // 选择文件
  async selectFile() {
    try {
      this.addLog('开始选择文件...');

      const uri = await FilePickerUtils.selectFile();
      this.addLog(`已选择文件: ${uri}`);

      // 复制文件到沙盒
      const context = this.getUIContext().getHostContext();
      if (!context) {
        return;
      }
      this.addLog('正在复制文件到沙盒...');
      const fileInfo = await FilePickerUtils.copyFileToSandbox(uri, context);

      this.currentFileInfo = fileInfo;
      this.addLog(`文件复制完成: ${fileInfo.fileName}`);
      this.addLog(`原始URI: ${fileInfo.originalUri}`);
      this.addLog(`沙盒路径: ${fileInfo.sandboxPath}`);
      this.addLog(`文件信息: ${JSON.stringify(fileInfo.stat)}`);

    } catch (error) {
      this.addLog(`选择文件失败: ${error}`);
    }
  }

  // 上传文件
  async uploadFile() {
    if (!this.currentFileInfo) {
      this.addLog('请先选择文件');
      return;
    }

    this.isUploading = true;
    this.addLog('开始上传文件...');

    try {
      const result = await UploadUtils.uploadFile(
        this.currentFileInfo.sandboxPath,
        {
          serverUrl: this.serverUrl,
          uploadPath: this.uploadPath
        },
        (progress: number) => {
          const percent = Math.round(progress * 100);
          this.addLog(`上传进度: ${percent}%`);
        }
      );

      if (result.success) {
        this.addLog('上传成功!');
        this.addLog(`服务器响应: ${JSON.stringify(result.data, null, 2)}`);
      } else {
        this.addLog(`上传失败: ${result.message}`);
        if (result.error) {
          this.addLog(`错误详情: ${result.error}`);
        }
      }
    } catch (error) {
      this.addLog(`上传失败: ${error}`);
    } finally {
      this.isUploading = false;
    }
  }

  build() {
    Column({ space: 16 }) {
      // 固定内容区域 - 不可滚动
      Column({ space: 16 }) {
        // 标题
        Text('文件上传测试')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        // 服务器配置
        Column({ space: 8 }) {
          Text('服务器配置')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .alignSelf(ItemAlign.Start)

          TextInput({ placeholder: '服务器地址', text: this.serverUrl })
            .width('100%')
            .onChange((value: string) => {
              this.serverUrl = value;
            })

          TextInput({ placeholder: '上传路径 (默认: /upload)', text: this.uploadPath })
            .width('100%')
            .onChange((value: string) => {
              this.uploadPath = value;
            })
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)

        // 操作按钮
        Row({ space: 12 }) {
          Button('选择文件')
            .flexGrow(1)
            .height(48)
            .onClick(() => {
              this.selectFile();
            })

          Button('上传文件')
            .flexGrow(1)
            .height(48)
            .enabled(!this.isUploading && !!this.currentFileInfo)
            .onClick(() => {
              this.uploadFile();
            })

          Button('清空日志')
            .height(48)
            .onClick(() => {
              this.clearLogs();
            })
        }
        .width('100%')

        // 文件信息摘要
        if (this.currentFileInfo) {
          Column({ space: 4 }) {
            Text('当前文件')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .alignSelf(ItemAlign.Start)

            Text(`${this.currentFileInfo.fileName} (${(this.currentFileInfo.stat.size / 1024).toFixed(2)} KB)`)
              .fontSize(14)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(12)
          .backgroundColor('#E8F5E8')
          .borderRadius(6)
        }
      }
      .width('100%')

      // 日志显示区域 - 占满剩余空间且可滚动
      Column({ space: 8 }) {
        Text(`操作日志 (${this.logs.length})`)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        if (this.logs.length === 0) {
          Text('暂无日志')
            .fontSize(14)
            .fontColor('#999999')
            .alignSelf(ItemAlign.Start)
            .margin({ top: 20 })
        } else {
          Scroll() {
            Column({ space: 4 }) {
              ForEach(this.logs, (log: string, index: number) => {
                Text(log)
                  .fontSize(12)
                  .fontColor('#333333')
                  .textAlign(TextAlign.Start)
                  .width('100%')
                  .padding({
                    left: 8,
                    right: 8,
                    top: 4,
                    bottom: 4
                  })
                  .backgroundColor(index % 2 === 0 ? '#F8F8F8' : '#FFFFFF')
              })
            }
            .width('100%')
          }
          .width('100%')
          .layoutWeight(1)
          .backgroundColor('#F0F0F0')
          .borderRadius(4)
          .padding(4)
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Auto)
        }
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16, bottom: 20 })
    .align(Alignment.Top)
  }

  // 添加日志
  private addLog(message: string) {
    const timestamp = new Date().toLocaleTimeString();
    this.logs.push(`[${timestamp}] ${message}`);
  }

  // 清空日志
  private clearLogs() {
    this.logs = [];
  }
}