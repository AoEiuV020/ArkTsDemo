import { common } from '@kit.AbilityKit'

import {
  LANGUAGE_EN_US,
  LANGUAGE_ZH_HANS,
  LANGUAGE_ZH_HANT_TW,
  LanguageProbe,
  LanguageProbeKey,
  LanguageProbeRuntime,
  LanguageProbeStore,
  LanguageSnapshotStore,
} from '../LanguageProbe'

const PAGE_PADDING = 16
const SECTION_SPACE = 10
const BUTTON_HEIGHT = 40
const TITLE_FONT_SIZE = 22
const SECTION_TITLE_FONT_SIZE = 18
const BODY_FONT_SIZE = 14
const SMALL_FONT_SIZE = 12

interface InfoLineParams {
  label: string
  value: string
}

interface ProbeSectionParams {
  title: string
  store: LanguageProbeStore
}

@Entry
@ComponentV2
struct Index {
  @Local onCreateStore: LanguageProbeStore = LanguageProbe.connectProbe(LanguageProbeKey.ON_CREATE)
  @Local loadContentStore: LanguageProbeStore = LanguageProbe.connectProbe(LanguageProbeKey.LOAD_CONTENT)
  @Local pageAppearStore: LanguageProbeStore = LanguageProbe.connectProbe(LanguageProbeKey.PAGE_APPEAR)
  @Local buttonOnlyStore: LanguageProbeStore = LanguageProbe.connectProbe(LanguageProbeKey.BUTTON_ONLY)
  @Local languageStore: LanguageSnapshotStore = LanguageProbe.connectLanguageSnapshot()
  @Local lastAction: string = '未操作'

  aboutToAppear() {
    console.log('[LanguageProbe] Index.aboutToAppear 开始')
    this.lastAction = LanguageProbe.runPageAppearProbe()
    LanguageProbe.readManualLanguage(this.getAbilityContext(), '页面进入实时读取')
    console.log(`[LanguageProbe] Index.aboutToAppear 结束 lastAction=${this.lastAction}`)
  }

  build() {
    Scroll() {
      Column({ space: SECTION_SPACE }) {
        Text($r('app.string.language_probe_title'))
          .fontSize(TITLE_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          .width('100%')

        Text($r('app.string.language_probe_sample'))
          .fontSize(BODY_FONT_SIZE)
          .width('100%')

        this.RuntimeResultSection()
        this.PersistenceSection()
        this.LanguageSection()
      }
      .width('100%')
      .padding(PAGE_PADDING)
      .alignItems(HorizontalAlign.Start)
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  private RuntimeResultSection() {
    Column({ space: SECTION_SPACE }) {
      Text('启动阶段结果')
        .fontSize(SECTION_TITLE_FONT_SIZE)
        .fontWeight(FontWeight.Medium)
      this.InfoLine({ label: 'onCreate PersistenceV2', value: LanguageProbeRuntime.onCreateProbeResult })
      this.InfoLine({ label: 'loadContent PersistenceV2', value: LanguageProbeRuntime.loadContentProbeResult })
      this.InfoLine({ label: 'onCreate 语言读取', value: LanguageProbeRuntime.onCreateLanguageResult })
      this.InfoLine({ label: 'loadContent 语言读取', value: LanguageProbeRuntime.loadContentLanguageResult })
      this.InfoLine({ label: '页面最近操作', value: this.lastAction })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private PersistenceSection() {
    Column({ space: SECTION_SPACE }) {
      Text('PersistenceV2 独立 key')
        .fontSize(SECTION_TITLE_FONT_SIZE)
        .fontWeight(FontWeight.Medium)
      Text('每组 key 互相独立。写入后杀进程重启，看“connect 读到”是否是上次写入值。')
        .fontSize(SMALL_FONT_SIZE)
        .width('100%')
      Button('写 onCreate key')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：写 onCreate key')
          this.lastAction = LanguageProbe.runButtonProbe(LanguageProbeKey.ON_CREATE, '按钮写 onCreate key')
        })
      Button('写 loadContent key')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：写 loadContent key')
          this.lastAction = LanguageProbe.runButtonProbe(LanguageProbeKey.LOAD_CONTENT, '按钮写 loadContent key')
        })
      Button('写页面 aboutToAppear key')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：写页面 aboutToAppear key')
          this.lastAction = LanguageProbe.runButtonProbe(LanguageProbeKey.PAGE_APPEAR, '按钮写页面 key')
        })
      Button('写按钮专用 key')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：写按钮专用 key')
          this.lastAction = LanguageProbe.runButtonProbe(LanguageProbeKey.BUTTON_ONLY, '按钮写专用 key')
        })
      this.ProbeSection({ title: 'onCreate key', store: this.onCreateStore })
      this.ProbeSection({ title: 'loadContent key', store: this.loadContentStore })
      this.ProbeSection({ title: '页面 aboutToAppear key', store: this.pageAppearStore })
      this.ProbeSection({ title: '按钮专用 key', store: this.buttonOnlyStore })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private LanguageSection() {
    Column({ space: SECTION_SPACE }) {
      Text('语言 API 读写')
        .fontSize(SECTION_TITLE_FONT_SIZE)
        .fontWeight(FontWeight.Medium)
      Text('启动阶段只读不写。点击单边设置后立刻读两边，再杀进程重启看 onCreate/loadContent 读到什么。')
        .fontSize(SMALL_FONT_SIZE)
        .width('100%')
      Button('实时读取两边语言')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：实时读取两边语言')
          LanguageProbe.readManualLanguage(this.getAbilityContext(), '手动实时读取')
        })
      Button('只 setAppPreferredLanguage(en-US)')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：只 setAppPreferredLanguage(en-US)')
          LanguageProbe.setPreferredLanguage(this.getAbilityContext(), LANGUAGE_EN_US)
        })
      Button('只 setLanguage(en-US)')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：只 setLanguage(en-US)')
          LanguageProbe.setRuntimeLanguage(this.getAbilityContext(), LANGUAGE_EN_US)
        })
      Button('两者都设 en-US')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：两者都设 en-US')
          LanguageProbe.setBothLanguages(this.getAbilityContext(), LANGUAGE_EN_US)
        })
      Button('只 setAppPreferredLanguage(zh-Hans)')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：只 setAppPreferredLanguage(zh-Hans)')
          LanguageProbe.setPreferredLanguage(this.getAbilityContext(), LANGUAGE_ZH_HANS)
        })
      Button('只 setLanguage(zh-Hans)')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：只 setLanguage(zh-Hans)')
          LanguageProbe.setRuntimeLanguage(this.getAbilityContext(), LANGUAGE_ZH_HANS)
        })
      Button('两者都设 zh-Hans')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：两者都设 zh-Hans')
          LanguageProbe.setBothLanguages(this.getAbilityContext(), LANGUAGE_ZH_HANS)
        })
      Button('只 setAppPreferredLanguage(zh-Hant-TW)')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：只 setAppPreferredLanguage(zh-Hant-TW)')
          LanguageProbe.setPreferredLanguage(this.getAbilityContext(), LANGUAGE_ZH_HANT_TW)
        })
      Button('只 setLanguage(zh-Hant-TW)')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：只 setLanguage(zh-Hant-TW)')
          LanguageProbe.setRuntimeLanguage(this.getAbilityContext(), LANGUAGE_ZH_HANT_TW)
        })
      Button('两者都设 zh-Hant-TW')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：两者都设 zh-Hant-TW')
          LanguageProbe.setBothLanguages(this.getAbilityContext(), LANGUAGE_ZH_HANT_TW)
        })
      Button('偏好语言设为 default')
        .width('100%')
        .height(BUTTON_HEIGHT)
        .onClick(() => {
          console.log('[LanguageProbe] 点击按钮：偏好语言设为 default')
          LanguageProbe.resetPreferredLanguage(this.getAbilityContext())
        })
      this.InfoLine({ label: 'onCreate system', value: this.languageStore.onCreateSystem })
      this.InfoLine({ label: 'onCreate preferred', value: this.languageStore.onCreatePreferred })
      this.InfoLine({ label: 'onCreate runtime', value: this.languageStore.onCreateRuntime })
      this.InfoLine({ label: 'onCreate at', value: this.languageStore.onCreateAt })
      this.InfoLine({ label: 'loadContent system', value: this.languageStore.loadContentSystem })
      this.InfoLine({ label: 'loadContent preferred', value: this.languageStore.loadContentPreferred })
      this.InfoLine({ label: 'loadContent runtime', value: this.languageStore.loadContentRuntime })
      this.InfoLine({ label: 'loadContent at', value: this.languageStore.loadContentAt })
      this.InfoLine({ label: '实时 system', value: this.languageStore.manualSystem })
      this.InfoLine({ label: '实时 preferred', value: this.languageStore.manualPreferred })
      this.InfoLine({ label: '实时 runtime', value: this.languageStore.manualRuntime })
      this.InfoLine({ label: '实时动作', value: this.languageStore.manualAction })
      this.InfoLine({ label: '实时 at', value: this.languageStore.manualAt })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private ProbeSection(params: ProbeSectionParams) {
    Column({ space: 4 }) {
      Text(params.title)
        .fontSize(BODY_FONT_SIZE)
        .fontWeight(FontWeight.Medium)
      this.InfoLine({ label: 'connect 读到', value: params.store.connectReadValue })
      this.InfoLine({ label: '当前 value', value: params.store.value })
      this.InfoLine({ label: '写入后重连读到', value: params.store.reconnectReadValue })
      this.InfoLine({ label: '来源', value: params.store.source })
      this.InfoLine({ label: '次数', value: params.store.runCount.toString() })
      this.InfoLine({ label: '时间', value: params.store.lastAt })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private InfoLine(params: InfoLineParams) {
    Row() {
      Text(params.label)
        .fontSize(BODY_FONT_SIZE)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
      Text(params.value)
        .fontSize(BODY_FONT_SIZE)
        .textAlign(TextAlign.End)
        .layoutWeight(1)
    }
    .width('100%')
  }

  private getAbilityContext(): common.UIAbilityContext {
    return this.getUIContext().getHostContext() as common.UIAbilityContext
  }
}
