import { rcp } from '@kit.RemoteCommunicationKit'
import { WebNetErrorList, webview } from '@kit.ArkWeb'
import { CorsProxyOptions } from './CorsProxyOptions'

const TAG = '[HttpProxy]'

/** HTTP 代理类，用于绕过 CORS 限制 */
export class HttpProxy {
  private session: rcp.Session

  constructor() {
    console.info(`${TAG} 创建 HTTP 代理`)
    this.session = rcp.createSession()
  }

  /** 代理 GET 请求 */
  get(url: string, resourceHandler: webview.WebResourceHandler, options: CorsProxyOptions): void {
    console.info(`${TAG} GET 请求开始 url=${url}`)
    this.session.get(url).then((res) => {
      console.info(`${TAG} GET 请求成功 statusCode=${res.statusCode}`)
      this.handleResponse(res, resourceHandler, options)
    }).catch((error: Error) => {
      console.error(`${TAG} GET 请求失败: ${error.message}`)
      this.handleError(resourceHandler, error)
    })
  }

  /** 处理响应并添加 CORS 头 */
  private handleResponse(res: rcp.Response, resourceHandler: webview.WebResourceHandler,
    options: CorsProxyOptions): void {
    console.info(`${TAG} 处理响应 mimeType=${options.mimeType} requestOrigin=${options.requestOrigin}`)
    const response = new webview.WebSchemeHandlerResponse()
    response.setStatus(200)
    response.setStatusText('OK')
    response.setMimeType(options.mimeType)
    response.setEncoding('utf-8')
    response.setNetErrorCode(WebNetErrorList.NET_OK)
    response.setHeaderByName('Access-Control-Allow-Origin', options.requestOrigin, true)
    response.setHeaderByName('Access-Control-Allow-Credentials', 'true', true)
    response.setHeaderByName('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE', true)
    response.setHeaderByName('Access-Control-Allow-Headers', 'Content-Type, Authorization', true)
    try {
      resourceHandler.didReceiveResponse(response)
      resourceHandler.didReceiveResponseBody(res.body)
      resourceHandler.didFinish()
      console.info(`${TAG} 响应处理完成`)
    } catch (error) {
      console.error(`${TAG} 响应处理失败: ${(error as Error).message}`)
    }
  }

  /** 处理请求错误 */
  private handleError(resourceHandler: webview.WebResourceHandler, error: Error): void {
    console.error(`${TAG} 处理错误响应: ${error.message}`)
    const response = new webview.WebSchemeHandlerResponse()
    response.setStatus(500)
    response.setStatusText('Internal Server Error')
    response.setMimeType('application/json')
    response.setEncoding('utf-8')
    response.setNetErrorCode(WebNetErrorList.NET_OK)
    try {
      resourceHandler.didReceiveResponse(response)
      const errorBody = JSON.stringify({ error: error.message })
      const errorBytes = new Uint8Array(errorBody.length)
      for (let i = 0; i < errorBody.length; i++) {
        errorBytes[i] = errorBody.charCodeAt(i)
      }
      resourceHandler.didReceiveResponseBody(errorBytes.buffer as ArrayBuffer)
      resourceHandler.didFinish()
    } catch (e) {
      console.error(`${TAG} 错误响应处理失败: ${(e as Error).message}`)
    }
  }
}
