import { webview } from '@kit.ArkWeb'
import { HttpProxy } from './HttpProxy'
import { CorsProxyOptions } from './CorsProxyOptions'

const TAG = '[CorsInterceptor]'

/** CORS 拦截器，用于绕过跨域限制 */
export class CorsInterceptor {
  private controller: webview.WebviewController
  private schemeHandler: webview.WebSchemeHandler = new webview.WebSchemeHandler()
  private httpProxy: HttpProxy = new HttpProxy()
  private pageOrigin: string
  /** 需要代理的路径匹配正则 */
  private corsRegex: RegExp

  constructor(controller: webview.WebviewController, pageOrigin: string, corsPattern: string = '/api/') {
    this.controller = controller
    this.pageOrigin = pageOrigin
    this.corsRegex = new RegExp(corsPattern)
    console.info(`${TAG} 创建拦截器 pageOrigin=${pageOrigin} corsPattern=${corsPattern}`)
  }

  /** 启用 CORS 拦截，匹配正则的请求会被代理 */
  enable(): void {
    console.info(`${TAG} 启用拦截器`)
    this.schemeHandler.onRequestStart(
      (request: webview.WebSchemeHandlerRequest, resourceHandler: webview.WebResourceHandler) => {
        const requestUrl = request.getRequestUrl()
        const method = request.getRequestMethod()
        console.info(`${TAG} onRequestStart method=${method} url=${requestUrl}`)
        // 判断是否匹配需要代理的路径正则
        if (this.corsRegex.test(requestUrl)) {
          console.info(`${TAG} 拦截匹配路径请求 regex=${this.corsRegex}`)
          const options: CorsProxyOptions = {
            mimeType: 'application/json',
            requestOrigin: this.pageOrigin,
          }
          this.httpProxy.get(requestUrl, resourceHandler, options)
          return true
        }
        console.info(`${TAG} 不拦截，路径不匹配`)
        return false
      })
    this.controller.setWebSchemeHandler('https', this.schemeHandler)
    this.controller.setWebSchemeHandler('http', this.schemeHandler)
    console.info(`${TAG} 拦截器设置完成`)
  }

  /** 禁用 CORS 拦截，释放资源 */
  disable(): void {
    console.info(`${TAG} 禁用拦截器`)
    this.controller.clearWebSchemeHandler()
  }
}
