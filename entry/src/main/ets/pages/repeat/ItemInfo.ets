import { Item } from './Item';

// 可观测的ItemInfo，包含item和选中状态
@ObservedV2
export class ItemInfo {
  @Trace item: Item;
  @Trace isSelected: boolean;

  constructor(item: Item, isSelected: boolean = false) {
    this.item = item;
    this.isSelected = isSelected;
  }

  // 切换选中状态
  toggleSelected(): void {
    this.isSelected = !this.isSelected;
  }

  // 更新item名称
  updateName(newName: string): void {
    this.item = {
      id: this.item.id,
      name: newName,
    }
  }
}
