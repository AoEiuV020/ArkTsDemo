import { webview } from '@kit.ArkWeb'
import { HttpProxy } from './HttpProxy'
import { CorsProxyOptions } from './CorsProxyOptions'

/** CORS 拦截器，用于绕过跨域限制 */
export class CorsInterceptor {
  private controller: webview.WebviewController
  private schemeHandler: webview.WebSchemeHandler = new webview.WebSchemeHandler()
  private httpProxy: HttpProxy = new HttpProxy()
  private pageOrigin: string

  constructor(controller: webview.WebviewController, pageOrigin: string) {
    this.controller = controller
    this.pageOrigin = pageOrigin
  }

  /** 启用 CORS 拦截，所有跨域请求都会被代理 */
  enable(): void {
    this.schemeHandler.onRequestStart(
      (request: webview.WebSchemeHandlerRequest, resourceHandler: webview.WebResourceHandler) => {
        const requestUrl = request.getRequestUrl()
        // 判断是否跨域：请求 URL 不以页面 origin 开头
        if (!requestUrl.startsWith(this.pageOrigin)) {
          const options: CorsProxyOptions = {
            mimeType: this.guessMimeType(requestUrl),
            requestOrigin: this.pageOrigin,
          }
          this.httpProxy.get(requestUrl, resourceHandler, options)
          return true
        }
        return false
      })
    this.controller.setWebSchemeHandler('https', this.schemeHandler)
    this.controller.setWebSchemeHandler('http', this.schemeHandler)
  }

  /** 根据 URL 猜测 MIME 类型 */
  private guessMimeType(url: string): string {
    if (url.endsWith('.json')) {
      return 'application/json'
    }
    if (url.endsWith('.js')) {
      return 'application/javascript'
    }
    if (url.endsWith('.css')) {
      return 'text/css'
    }
    if (url.endsWith('.html')) {
      return 'text/html'
    }
    if (url.endsWith('.png')) {
      return 'image/png'
    }
    if (url.endsWith('.jpg') || url.endsWith('.jpeg')) {
      return 'image/jpeg'
    }
    if (url.endsWith('.gif')) {
      return 'image/gif'
    }
    if (url.endsWith('.svg')) {
      return 'image/svg+xml'
    }
    return 'application/octet-stream'
  }
}
