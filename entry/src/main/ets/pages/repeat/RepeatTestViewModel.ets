import { Item } from './Item';
import { ItemInfo } from './ItemInfo';

// ViewModel层，处理业务逻辑
@ObservedV2
export class RepeatTestViewModel {
  @Trace dataList: Array<ItemInfo> = [];

  constructor() {
    this.initializeData();
  }

  // 处理item点击事件
  onItemClick(index: number): void {
    if (index >= 0 && index < this.dataList.length) {
      const itemInfo = this.dataList[index];
      const newName = itemInfo.item.name + '!';
      this.dataList[index] = new ItemInfo({
        id: itemInfo.item.id,
        name: newName,
      }, false)
    }
  }

  // 处理复选框状态改变
  onCheckboxChange(index: number, isChecked: boolean): void {
    if (index >= 0 && index < this.dataList.length) {
      this.dataList[index].isSelected = isChecked;
    }
  }

  // 切换item选中状态
  toggleItemSelection(index: number): void {
    if (index >= 0 && index < this.dataList.length) {
      this.dataList[index].toggleSelected();
    }
  }

  // 获取选中的item数量
  getSelectedCount(): number {
    return this.dataList.filter(itemInfo => itemInfo.isSelected).length;
  }

  // 获取选中的items
  getSelectedItems(): Array<Item> {
    return this.dataList
      .filter(itemInfo => itemInfo.isSelected)
      .map(itemInfo => itemInfo.item);
  }

  // 全选/全不选
  selectAll(selectAll: boolean): void {
    this.dataList.forEach(itemInfo => {
      itemInfo.isSelected = selectAll;
    });
  }

  // 初始化数据
  private initializeData(): void {
    this.dataList = [];
    for (let i = 0; i < 50; i++) {
      const item: Item = {
        id: i,
        name: `Item_${i}`
      };
      this.dataList.push(new ItemInfo(item));
    }
  }
}
