import { Item } from './Item';
import { UIUtils } from '@kit.ArkUI';

// 可观测的ItemInfo，包含item和选中状态
@ObservedV2
export class ItemInfo {
  @Trace item: Item;
  @Trace isSelected: boolean;

  constructor(item: Item, isSelected: boolean = false) {
    this.item = UIUtils.makeObserved(item);
    this.isSelected = isSelected;
  }

  // 切换选中状态
  toggleSelected(): void {
    this.isSelected = !this.isSelected;
  }
}
