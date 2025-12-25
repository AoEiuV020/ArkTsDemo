import { router } from '@kit.ArkUI'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { LatLng } from '@bdmap/base'
import {
  MapComponent,
  MapController,
  MapOptions,
  MapStatus,
  MapEvent,
  Marker,
  ImageEntity,
  SysEnum,
  EventBundle
} from '@bdmap/map'
import {
  GeoCoder,
  ReverseGeoCodeOption,
  PoiInfo
} from '@bdmap/search'
import type { ReverseGeoCodeResult } from '@bdmap/search'

const DOMAIN = 0x0000

/**
 * 选中的地点信息
 */
export interface SelectedLocation {
  /** 纬度 */
  latitude: number
  /** 经度 */
  longitude: number
  /** 地址名称 */
  name: string
  /** 详细地址 */
  address: string
}

/**
 * 页面入参
 */
interface MapSelectParams {
  /** 初始纬度 */
  latitude?: number
  /** 初始经度 */
  longitude?: number
  /** 地点名称（查看模式） */
  name?: string
  /** 是否为查看模式（只查看不选择） */
  viewOnly?: boolean
}

@Entry
@ComponentV2
struct MapSelectPage {
  /** 地图控制器 */
  private mapController: MapController | null = null
  /** 中心点标记 */
  private centerMarker: Marker | null = null
  /** 固定位置标记（查看模式） */
  private fixedMarker: Marker | null = null
  /** 选中的位置 */
  @Local selectedLocation: SelectedLocation | null = null
  /** 附近POI列表 */
  @Local poiList: PoiInfo[] = []
  /** 是否正在加载 */
  @Local isLoading: boolean = true
  /** 是否为查看模式 */
  @Local viewOnly: boolean = false
  /** 页面参数 */
  private pageParams: MapSelectParams | null = null

  aboutToAppear(): void {
    this.pageParams = router.getParams() as MapSelectParams | null
    this.viewOnly = this.pageParams?.viewOnly ?? false
  }

  /**
   * 获取初始地图配置
   */
  private getMapOptions(): MapOptions {
    const lat = this.pageParams?.latitude ?? 39.909
    const lng = this.pageParams?.longitude ?? 116.397
    return new MapOptions({
      mapStatus: new MapStatus({
        zoom: 16,
        center: new LatLng(lat, lng)
      })
    })
  }

  /**
   * 地图加载完成回调
   */
  private onMapReady(err: Error | null, controller: MapController): void {
    if (err) {
      hilog.error(DOMAIN, 'MapSelectPage', '地图加载失败: %{public}s', err.message)
      this.isLoading = false
      return
    }

    this.mapController = controller
    this.isLoading = false
    hilog.info(DOMAIN, 'MapSelectPage', '地图加载成功')

    if (this.viewOnly) {
      // 查看模式：添加固定标记
      this.addFixedMarker()
    } else {
      // 选择模式：监听地图状态变化
      this.setupMapListeners()
      // 初始获取中心点信息
      this.updateCenterLocation()
    }
  }

  /**
   * 添加固定位置标记（查看模式）
   */
  private addFixedMarker(): void {
    if (!this.pageParams) return
    const lat = this.pageParams.latitude ?? 39.909
    const lng = this.pageParams.longitude ?? 116.397

    this.fixedMarker = new Marker({
      position: new LatLng(lat, lng),
      icon: new ImageEntity('rawfile://map_marker_red.png'),
      located: SysEnum.Located.BOTTOM,
      isJoinCollision: SysEnum.CollisionBehavior.NOT_COLLIDE
    })
    this.mapController?.addOverlay(this.fixedMarker)

    // 设置选中位置信息
    this.selectedLocation = {
      latitude: lat,
      longitude: lng,
      name: this.pageParams.name ?? '选中位置',
      address: `${lat.toFixed(6)}, ${lng.toFixed(6)}`
    }
  }

  /**
   * 设置地图监听器（选择模式）
   */
  private setupMapListeners(): void {
    // 地图移动结束后更新中心点信息
    this.mapController?.addEventListener(MapEvent.MAPSTATUSCHANGEFINISH, () => {
      this.updateCenterLocation()
    })
  }

  /**
   * 更新中心点位置信息
   */
  private updateCenterLocation(): void {
    const center = this.mapController?.mapStatus.getCenterPoint()
    if (!center) return

    hilog.info(DOMAIN, 'MapSelectPage', '中心点: %{public}s', JSON.stringify(center))

    // 逆地理编码获取地址信息
    const geocoder = GeoCoder.newInstance()
    const option = new ReverseGeoCodeOption({
      location: center,
      radius: 500,
      pageNum: 0
    })

    geocoder.reverseGeoCode(option)
      .then((res: ReverseGeoCodeResult) => {
        // 更新POI列表
        this.poiList = res.poiList ?? []

        // 设置选中位置
        const firstPoi = this.poiList[0]
        this.selectedLocation = {
          latitude: center.lat,
          longitude: center.lng,
          name: firstPoi?.name ?? '当前位置',
          address: firstPoi?.address ?? `${center.lat.toFixed(6)}, ${center.lng.toFixed(6)}`
        }
      })
      .catch((err: Error) => {
        hilog.error(DOMAIN, 'MapSelectPage', '逆地理编码失败: %{public}s', err.message)
        this.selectedLocation = {
          latitude: center.lat,
          longitude: center.lng,
          name: '选中位置',
          address: `${center.lat.toFixed(6)}, ${center.lng.toFixed(6)}`
        }
      })
  }

  /**
   * 点击POI列表项
   */
  private onPoiItemClick(poi: PoiInfo): void {
    if (!poi.location) return

    // 移动地图到该POI位置
    this.mapController?.setMapCenter(poi.location, 17)

    // 更新选中信息
    this.selectedLocation = {
      latitude: poi.location.lat,
      longitude: poi.location.lng,
      name: poi.name ?? '选中位置',
      address: poi.address ?? `${poi.location.lat.toFixed(6)}, ${poi.location.lng.toFixed(6)}`
    }
  }

  /**
   * 确认选择并返回首页
   */
  private confirmSelection(): void {
    if (this.selectedLocation) {
      hilog.info(DOMAIN, 'MapSelectPage', '确认选择: %{public}s', JSON.stringify(this.selectedLocation))
      router.back({
        url: 'pages/Index',
        params: {
          selectedLocation: this.selectedLocation
        }
      })
    }
  }

  /**
   * 取消选择返回首页
   */
  private cancelSelection(): void {
    router.back()
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button(this.viewOnly ? '返回' : '取消')
          .fontSize(16)
          .fontColor('#333333')
          .backgroundColor(Color.Transparent)
          .onClick(() => this.cancelSelection())

        Text(this.viewOnly ? '查看位置' : '选择地点')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        if (!this.viewOnly) {
          Button('确定')
            .fontSize(16)
            .fontColor(this.selectedLocation ? '#007AFF' : '#999999')
            .backgroundColor(Color.Transparent)
            .enabled(this.selectedLocation !== null)
            .onClick(() => this.confirmSelection())
        } else {
          Text('').width(60)
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 地图区域
      Stack() {
        MapComponent({
          onReady: (err, controller) => this.onMapReady(err, controller),
          mapOptions: this.getMapOptions()
        })
          .width('100%')
          .height('100%')

        // 中心点标记（选择模式）
        if (!this.viewOnly) {
          Image($r('app.media.startIcon'))
            .width(32)
            .height(32)
        }

        // 加载提示
        if (this.isLoading) {
          Column() {
            LoadingProgress()
              .width(50)
              .height(50)
            Text('地图加载中...')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ top: 10 })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#FFFFFF')
          .justifyContent(FlexAlign.Center)
        }
      }
      .layoutWeight(1)
      .width('100%')

      // 底部选中信息和POI列表
      if (this.selectedLocation) {
        Column() {
          // 选中的地点信息
          Row() {
            Column() {
              Text(this.selectedLocation.name)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(this.selectedLocation.address)
                .fontSize(14)
                .fontColor('#666666')
                .margin({ top: 4 })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')

          // POI列表（选择模式）
          if (!this.viewOnly && this.poiList.length > 1) {
            Divider().color('#EEEEEE').height(1)
            List({ space: 0 }) {
              ForEach(this.poiList.slice(1), (poi: PoiInfo) => {
                ListItem() {
                  Row() {
                    Column() {
                      Text(poi.name ?? '')
                        .fontSize(14)
                        .fontColor('#333333')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(poi.address ?? '')
                        .fontSize(12)
                        .fontColor('#999999')
                        .margin({ top: 2 })
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                  }
                  .width('100%')
                  .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                  .onClick(() => this.onPoiItemClick(poi))
                }
              })
            }
            .width('100%')
            .height(150)
            .backgroundColor('#FFFFFF')
            .divider({ strokeWidth: 1, color: '#EEEEEE', startMargin: 16, endMargin: 16 })
          }
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
