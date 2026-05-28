import { common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { PersistenceV2 } from '@kit.ArkUI'
import { i18n } from '@kit.LocalizationKit'

/*
 * 语言与 PersistenceV2 探针。
 *
 * 预期效果：
 * - onCreate、loadContent、页面和按钮分别连接独立 key，当前进程内写入后重连都应读到最新值。
 * - 杀进程重启后，loadContent 和页面阶段应恢复上次写入值；onCreate 阶段可能首读默认值。
 * - 语言按钮单独调用 setAppPreferredLanguage 或 setLanguage 后立即读取 system、preferred、runtime，
 *   用于确认应用偏好语言和当前进程运行时语言是否互相影响。
 * - 重启后再看 onCreate、loadContent 和页面实时读取值，确认冷启动语言由应用偏好语言还是运行时设置决定。
 *
 * 当前日志已验证：
 * - onCreate、loadContent、页面和按钮专用 key 在当前进程内均可同步读写，且不同 key 不互相污染。
 * - onCreate 阶段冷启动首读多次为默认值，不适合做启动关键标志来源。
 * - loadContent 和页面阶段冷启动可恢复上次写入值，适合页面级 UI 状态。
 * - setAppPreferredLanguage('zh-Hans') 和 setAppPreferredLanguage('en-US') 会立即让 preferred 和 runtime 都变为目标语言，并在冷启动后保持。
 * - setAppPreferredLanguage('zh-Hant-TW') 会立即让 preferred 和 runtime 都变为 zh-Hant-TW，并在冷启动后保持。
 * - setLanguage 只改变当前进程 runtime，不改变 preferred；冷启动语言仍由 preferred 或 default 系统匹配结果决定。
 * - setAppPreferredLanguage('default') 会立即恢复 preferred，但当前进程 runtime 可能保持旧语言；英文和繁体系统环境日志均未读回 preferred=default。
 * - default 后冷启动时，preferred 和 runtime 会恢复到系统匹配语言，例如 en-Latn-CN 或 zh-Hant-CN；从固定 zh-Hant-TW 恢复 default 后，当前进程 runtime 仍可能保持 zh-Hant-TW。
 * - default 后补 setLanguage(mappedLanguage) 可以立即切换当前进程 runtime，且不会覆盖 default 的冷启动跟随系统语义。
 *
 * 正确做法：
 * - 固定语言优先调用 setAppPreferredLanguage(targetLanguage)，同时更新应用自有语言状态。
 * - 跟随系统先调用 setAppPreferredLanguage('default')，当前进程需要立即切换时再调用 setLanguage(mappedLanguage)。
 * - 业务语言状态以应用自有持久化状态为准，不用系统 API 读值替代业务状态。
 * - 只需要首次按系统语言初始化后固定的场景，不要判断 getAppPreferredLanguage() 是否等于 default；应映射读到的语言标签并固定保存。
 * - 启动关键标志使用 Preferences 或业务持久化，不依赖 onCreate 阶段的 PersistenceV2 首读。
 */
export const LANGUAGE_ZH_HANS = 'zh-Hans'
export const LANGUAGE_ZH_HANT_TW = 'zh-Hant-TW'
export const LANGUAGE_EN_US = 'en-US'

export class LanguageProbeKey {
  static readonly ON_CREATE: string = 'LanguageProbeOnCreate'
  static readonly LOAD_CONTENT: string = 'LanguageProbeLoadContent'
  static readonly PAGE_APPEAR: string = 'LanguageProbePageAppear'
  static readonly BUTTON_ONLY: string = 'LanguageProbeButtonOnly'
  static readonly LANGUAGE_SNAPSHOT: string = 'LanguageProbeLanguageSnapshot'
}

export class LanguageProbeRuntime {
  static onCreateProbeResult: string = '未执行'
  static loadContentProbeResult: string = '未执行'
  static onCreateLanguageResult: string = '未执行'
  static loadContentLanguageResult: string = '未执行'
}

@ObservedV2
export class LanguageProbeStore {
  @Trace value: string = '默认值'
  @Trace connectReadValue: string = '未执行'
  @Trace writeValue: string = '未执行'
  @Trace reconnectReadValue: string = '未执行'
  @Trace source: string = '未执行'
  @Trace runCount: number = 0
  @Trace lastAt: string = '未执行'
}

@ObservedV2
export class LanguageSnapshotStore {
  @Trace onCreateSystem: string = '未执行'
  @Trace onCreatePreferred: string = '未执行'
  @Trace onCreateRuntime: string = '未执行'
  @Trace onCreateAt: string = '未执行'
  @Trace loadContentSystem: string = '未执行'
  @Trace loadContentPreferred: string = '未执行'
  @Trace loadContentRuntime: string = '未执行'
  @Trace loadContentAt: string = '未执行'
  @Trace manualSystem: string = '未读取'
  @Trace manualPreferred: string = '未读取'
  @Trace manualRuntime: string = '未读取'
  @Trace manualAt: string = '未读取'
  @Trace manualAction: string = '未操作'
}

export class LanguageProbe {
  static connectProbe(key: string): LanguageProbeStore {
    LanguageProbe.log(`connectProbe 开始 key=${key}`)
    const store = PersistenceV2.globalConnect({
      type: LanguageProbeStore,
      key: key,
      defaultCreator: () => new LanguageProbeStore(),
    })!
    LanguageProbe.logStore(`connectProbe 完成 key=${key}`, store)
    return store
  }

  static connectLanguageSnapshot(): LanguageSnapshotStore {
    LanguageProbe.log('connectLanguageSnapshot 开始')
    const store = PersistenceV2.globalConnect({
      type: LanguageSnapshotStore,
      key: LanguageProbeKey.LANGUAGE_SNAPSHOT,
      defaultCreator: () => new LanguageSnapshotStore(),
    })!
    LanguageProbe.logLanguageSnapshot('connectLanguageSnapshot 完成', store)
    return store
  }

  static runOnCreateProbe() {
    LanguageProbe.log('runOnCreateProbe 开始')
    LanguageProbeRuntime.onCreateProbeResult = LanguageProbe.runProbe(LanguageProbeKey.ON_CREATE, 'EntryAbility.onCreate')
    LanguageProbe.log(`runOnCreateProbe 结束 result=${LanguageProbeRuntime.onCreateProbeResult}`)
  }

  static runLoadContentProbe() {
    LanguageProbe.log('runLoadContentProbe 开始')
    LanguageProbeRuntime.loadContentProbeResult = LanguageProbe.runProbe(LanguageProbeKey.LOAD_CONTENT, 'loadContent 成功回调')
    LanguageProbe.log(`runLoadContentProbe 结束 result=${LanguageProbeRuntime.loadContentProbeResult}`)
  }

  static runPageAppearProbe(): string {
    LanguageProbe.log('runPageAppearProbe 开始')
    const result = LanguageProbe.runProbe(LanguageProbeKey.PAGE_APPEAR, '页面 aboutToAppear')
    LanguageProbe.log(`runPageAppearProbe 结束 result=${result}`)
    return result
  }

  static runButtonProbe(key: string, source: string): string {
    LanguageProbe.log(`runButtonProbe 开始 key=${key}, source=${source}`)
    const result = LanguageProbe.runProbe(key, source)
    LanguageProbe.log(`runButtonProbe 结束 key=${key}, result=${result}`)
    return result
  }

  static recordOnCreateLanguage(context: common.UIAbilityContext) {
    LanguageProbe.log('recordOnCreateLanguage 开始')
    LanguageProbe.logCurrentLanguage(context, 'recordOnCreateLanguage 设置前读取')
    LanguageProbeRuntime.onCreateLanguageResult = LanguageProbe.recordStartupLanguage(context, 'onCreate')
    LanguageProbe.log(`recordOnCreateLanguage 结束 result=${LanguageProbeRuntime.onCreateLanguageResult}`)
  }

  static recordLoadContentLanguage(context: common.UIAbilityContext) {
    LanguageProbe.log('recordLoadContentLanguage 开始')
    LanguageProbe.logCurrentLanguage(context, 'recordLoadContentLanguage 设置前读取')
    LanguageProbeRuntime.loadContentLanguageResult = LanguageProbe.recordStartupLanguage(context, 'loadContent')
    LanguageProbe.log(`recordLoadContentLanguage 结束 result=${LanguageProbeRuntime.loadContentLanguageResult}`)
  }

  static readManualLanguage(context: common.UIAbilityContext, action: string) {
    LanguageProbe.log(`readManualLanguage 开始 action=${action}`)
    LanguageProbe.logCurrentLanguage(context, 'readManualLanguage 读取前')
    const snapshot = LanguageProbe.connectLanguageSnapshot()
    LanguageProbe.fillManualLanguage(snapshot, context, action)
    LanguageProbe.logLanguageSnapshot('readManualLanguage 读取后', snapshot)
  }

  static setPreferredLanguage(context: common.UIAbilityContext, language: string) {
    try {
      LanguageProbe.log(`setPreferredLanguage 开始 language=${language}`)
      LanguageProbe.logCurrentLanguage(context, 'setPreferredLanguage 调用前')
      i18n.System.setAppPreferredLanguage(language)
      LanguageProbe.logCurrentLanguage(context, 'setPreferredLanguage 调用后')
      LanguageProbe.readManualLanguage(context, `setAppPreferredLanguage(${language})`)
    } catch (error) {
      LanguageProbe.recordLanguageError(`setAppPreferredLanguage(${language})失败`, error as BusinessError)
    }
  }

  static setRuntimeLanguage(context: common.UIAbilityContext, language: string) {
    try {
      LanguageProbe.log(`setRuntimeLanguage 开始 language=${language}`)
      LanguageProbe.logCurrentLanguage(context, 'setRuntimeLanguage 调用前')
      context.getApplicationContext().setLanguage(language)
      LanguageProbe.logCurrentLanguage(context, 'setRuntimeLanguage 调用后')
      LanguageProbe.readManualLanguage(context, `setLanguage(${language})`)
    } catch (error) {
      LanguageProbe.recordLanguageError(`setLanguage(${language})失败`, error as BusinessError)
    }
  }

  static setBothLanguages(context: common.UIAbilityContext, language: string) {
    try {
      LanguageProbe.log(`setBothLanguages 开始 language=${language}`)
      LanguageProbe.logCurrentLanguage(context, 'setBothLanguages 调用前')
      i18n.System.setAppPreferredLanguage(language)
      LanguageProbe.logCurrentLanguage(context, 'setBothLanguages setAppPreferredLanguage 后')
      context.getApplicationContext().setLanguage(language)
      LanguageProbe.logCurrentLanguage(context, 'setBothLanguages setLanguage 后')
      LanguageProbe.readManualLanguage(context, `两者都设置为 ${language}`)
    } catch (error) {
      LanguageProbe.recordLanguageError(`两者都设置为 ${language} 失败`, error as BusinessError)
    }
  }

  static resetPreferredLanguage(context: common.UIAbilityContext) {
    try {
      LanguageProbe.log('resetPreferredLanguage 开始')
      LanguageProbe.logCurrentLanguage(context, 'resetPreferredLanguage 调用前')
      i18n.System.setAppPreferredLanguage('default')
      LanguageProbe.logCurrentLanguage(context, 'resetPreferredLanguage 调用后')
      LanguageProbe.readManualLanguage(context, 'setAppPreferredLanguage(default)')
    } catch (error) {
      LanguageProbe.recordLanguageError('setAppPreferredLanguage(default)失败', error as BusinessError)
    }
  }

  private static runProbe(key: string, source: string): string {
    try {
      LanguageProbe.log(`runProbe 开始 key=${key}, source=${source}`)
      const store = LanguageProbe.connectProbe(key)
      const beforeValue = store.value
      LanguageProbe.log(`runProbe connect 后 key=${key}, beforeValue=${beforeValue}`)
      store.connectReadValue = beforeValue
      store.runCount += 1
      store.value = `${source} 写入 ${store.runCount} ${LanguageProbe.now()}`
      store.writeValue = store.value
      LanguageProbe.logStore(`runProbe 写入后 key=${key}`, store)
      store.reconnectReadValue = LanguageProbe.connectProbe(key).value
      store.source = source
      store.lastAt = LanguageProbe.now()
      LanguageProbe.logStore(`runProbe 重连后 key=${key}`, store)
      return '成功'
    } catch (error) {
      const message = LanguageProbe.formatError(error as BusinessError)
      LanguageProbe.log(`runProbe 失败 key=${key}, error=${message}`)
      return message
    }
  }

  private static recordStartupLanguage(context: common.UIAbilityContext, stage: string): string {
    try {
      LanguageProbe.log(`recordStartupLanguage 开始 stage=${stage}`)
      const snapshot = LanguageProbe.connectLanguageSnapshot()
      if (stage === 'onCreate') {
        snapshot.onCreateSystem = i18n.System.getSystemLanguage()
        snapshot.onCreatePreferred = i18n.System.getAppPreferredLanguage()
        snapshot.onCreateRuntime = LanguageProbe.getRuntimeLanguage(context)
        snapshot.onCreateAt = LanguageProbe.now()
      } else {
        snapshot.loadContentSystem = i18n.System.getSystemLanguage()
        snapshot.loadContentPreferred = i18n.System.getAppPreferredLanguage()
        snapshot.loadContentRuntime = LanguageProbe.getRuntimeLanguage(context)
        snapshot.loadContentAt = LanguageProbe.now()
      }
      LanguageProbe.logLanguageSnapshot(`recordStartupLanguage 完成 stage=${stage}`, snapshot)
      return '成功'
    } catch (error) {
      const message = LanguageProbe.formatError(error as BusinessError)
      LanguageProbe.log(`recordStartupLanguage 失败 stage=${stage}, error=${message}`)
      return message
    }
  }

  private static fillManualLanguage(snapshot: LanguageSnapshotStore, context: common.UIAbilityContext, action: string) {
    LanguageProbe.log(`fillManualLanguage 开始 action=${action}`)
    snapshot.manualSystem = i18n.System.getSystemLanguage()
    snapshot.manualPreferred = i18n.System.getAppPreferredLanguage()
    snapshot.manualRuntime = LanguageProbe.getRuntimeLanguage(context)
    snapshot.manualAt = LanguageProbe.now()
    snapshot.manualAction = action
    LanguageProbe.logLanguageSnapshot(`fillManualLanguage 完成 action=${action}`, snapshot)
  }

  private static recordLanguageError(action: string, error: BusinessError) {
    LanguageProbe.log(`recordLanguageError action=${action}, error=${LanguageProbe.formatError(error)}`)
    const snapshot = LanguageProbe.connectLanguageSnapshot()
    snapshot.manualAction = `${action}：${LanguageProbe.formatError(error)}`
    snapshot.manualAt = LanguageProbe.now()
    LanguageProbe.logLanguageSnapshot('recordLanguageError 写入后', snapshot)
  }

  private static getRuntimeLanguage(context: common.UIAbilityContext): string {
    return context.config.language || '未提供'
  }

  private static formatError(error: BusinessError): string {
    return `${error.code} ${error.message || '未知错误'}`
  }

  private static log(message: string) {
    console.log(`[LanguageProbe] ${LanguageProbe.now()} ${message}`)
  }

  private static logCurrentLanguage(context: common.UIAbilityContext, label: string) {
    console.log(`[LanguageProbe] ${LanguageProbe.now()} ${label} system=${i18n.System.getSystemLanguage()}, preferred=${i18n.System.getAppPreferredLanguage()}, runtime=${LanguageProbe.getRuntimeLanguage(context)}`)
  }

  private static logStore(label: string, store: LanguageProbeStore) {
    console.log(`[LanguageProbe] ${LanguageProbe.now()} ${label} value=${store.value}, connectRead=${store.connectReadValue}, write=${store.writeValue}, reconnectRead=${store.reconnectReadValue}, source=${store.source}, runCount=${store.runCount}, lastAt=${store.lastAt}`)
  }

  private static logLanguageSnapshot(label: string, store: LanguageSnapshotStore) {
    console.log(`[LanguageProbe] ${LanguageProbe.now()} ${label} onCreate(system=${store.onCreateSystem}, preferred=${store.onCreatePreferred}, runtime=${store.onCreateRuntime}, at=${store.onCreateAt}) loadContent(system=${store.loadContentSystem}, preferred=${store.loadContentPreferred}, runtime=${store.loadContentRuntime}, at=${store.loadContentAt}) manual(system=${store.manualSystem}, preferred=${store.manualPreferred}, runtime=${store.manualRuntime}, action=${store.manualAction}, at=${store.manualAt})`)
  }

  private static now(): string {
    return new Date().toTimeString().substring(0, 8)
  }
}
