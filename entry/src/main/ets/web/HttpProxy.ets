import { rcp } from '@kit.RemoteCommunicationKit'
import { WebNetErrorList, webview } from '@kit.ArkWeb'
import { CorsProxyOptions } from './CorsProxyOptions'

/** HTTP 代理类，用于绕过 CORS 限制 */
export class HttpProxy {
  private session: rcp.Session

  constructor() {
    this.session = rcp.createSession()
  }

  /** 代理 GET 请求 */
  get(url: string, resourceHandler: webview.WebResourceHandler, options: CorsProxyOptions): void {
    this.session.get(url).then((res) => {
      this.handleResponse(res, resourceHandler, options)
    }).catch((error: Error) => {
      console.error(`HttpProxy GET 失败: ${error.message}`)
    })
  }

  /** 代理 POST 请求 */
  post(url: string, resourceHandler: webview.WebResourceHandler, options: CorsProxyOptions): void {
    this.session.post(url).then((res) => {
      this.handleResponse(res, resourceHandler, options)
    }).catch((error: Error) => {
      console.error(`HttpProxy POST 失败: ${error.message}`)
    })
  }

  /** 处理响应并添加 CORS 头 */
  private handleResponse(res: rcp.Response, resourceHandler: webview.WebResourceHandler,
    options: CorsProxyOptions): void {
    const response = new webview.WebSchemeHandlerResponse()
    response.setStatus(200)
    response.setStatusText('OK')
    response.setMimeType(options.mimeType)
    response.setEncoding('utf-8')
    response.setNetErrorCode(WebNetErrorList.NET_OK)
    response.setHeaderByName('Access-Control-Allow-Origin', options.requestOrigin, true)
    response.setHeaderByName('Access-Control-Allow-Credentials', 'true', true)
    response.setHeaderByName('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS', true)
    response.setHeaderByName('Access-Control-Allow-Headers', 'Content-Type, Authorization', true)
    resourceHandler.didReceiveResponse(response)
    resourceHandler.didReceiveResponseBody(res.body)
    resourceHandler.didFinish()
  }
}
