import { Item } from './Item';
import { ItemInfo } from './ItemInfo';

// 数据管理器，专门管理ItemInfo数组
@ObservedV2
export class ItemDataManager {
  constructor() {
    this.initializeData();
  }

  @Trace private _dataList: Array<ItemInfo> = [];

  // 获取数据列表
  get dataList(): Array<ItemInfo> {
    return this._dataList;
  }

  // 获取指定索引的ItemInfo
  getItem(index: number): ItemInfo | null {
    if (index >= 0 && index < this._dataList.length) {
      return this._dataList[index];
    }
    return null;
  }

  // 更新指定索引的item名称
  updateItemName(index: number, newName: string): void {
    if (index >= 0 && index < this._dataList.length) {
      const itemInfo = this._dataList[index];
      this._dataList[index] = new ItemInfo({
        id: itemInfo.item.id,
        name: newName,
      }, itemInfo.isSelected);
    }
  }

  // 设置指定索引的选中状态
  setItemSelected(index: number, isSelected: boolean): void {
    if (index >= 0 && index < this._dataList.length) {
      this._dataList[index].isSelected = isSelected;
    }
  }

  // 切换指定索引的选中状态
  toggleItemSelected(index: number): void {
    if (index >= 0 && index < this._dataList.length) {
      this._dataList[index].toggleSelected();
    }
  }

  // 获取选中的item数量
  getSelectedCount(): number {
    return this._dataList.filter(itemInfo => itemInfo.isSelected).length;
  }

  // 获取选中的items
  getSelectedItems(): Array<Item> {
    return this._dataList
      .filter(itemInfo => itemInfo.isSelected)
      .map(itemInfo => itemInfo.item);
  }

  // 全选/全不选
  selectAll(selectAll: boolean): void {
    this._dataList.forEach(itemInfo => {
      itemInfo.isSelected = selectAll;
    });
  }

  // 获取数据总数
  getCount(): number {
    return this._dataList.length;
  }

  // 添加新item
  addItem(item: Item): void {
    this._dataList.push(new ItemInfo(item));
  }

  // 删除指定索引的item
  removeItem(index: number): void {
    if (index >= 0 && index < this._dataList.length) {
      this._dataList.splice(index, 1);
    }
  }

  // 清空所有数据
  clear(): void {
    this._dataList = [];
  }

  // 初始化数据
  private initializeData(): void {
    this._dataList = [];
    for (let i = 0; i < 50; i++) {
      const item: Item = {
        id: i,
        name: `Item_${i}`
      };
      this._dataList.push(new ItemInfo(item));
    }
  }
}
