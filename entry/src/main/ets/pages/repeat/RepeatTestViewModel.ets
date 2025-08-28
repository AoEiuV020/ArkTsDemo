import { Item } from './Item';
import { ItemInfo } from './ItemInfo';
import { ItemDataManager } from './ItemDataManager';

// ViewModel层，处理业务逻辑
@ObservedV2
export class RepeatTestViewModel {
  @Trace isCheckboxVisible: boolean = false; // 控制复选框显示隐藏
  @Trace private dataManager: ItemDataManager = new ItemDataManager();

  // 获取数据列表
  get dataList(): Array<ItemInfo> {
    return this.dataManager.dataList;
  }

  // 切换复选框显示状态
  toggleCheckboxVisible(): void {
    this.isCheckboxVisible = !this.isCheckboxVisible;
    // 如果隐藏复选框，清除所有选中状态
    if (!this.isCheckboxVisible) {
      this.dataManager.selectAll(false);
    }
  }

  // 处理item点击事件
  onItemClick(index: number): void {
    const itemInfo = this.dataManager.getItem(index);
    if (itemInfo) {
      const newName = itemInfo.item.name + '!';
      this.dataManager.updateItemName(index, newName);
    }
  }

  // 处理复选框状态改变
  onCheckboxChange(index: number, isChecked: boolean): void {
    this.dataManager.setItemSelected(index, isChecked);
  }

  // 切换item选中状态
  toggleItemSelection(index: number): void {
    this.dataManager.toggleItemSelected(index);
  }

  // 获取选中的item数量
  getSelectedCount(): number {
    return this.dataManager.getSelectedCount();
  }

  // 获取选中的items
  getSelectedItems(): Array<Item> {
    return this.dataManager.getSelectedItems();
  }

  // 全选/全不选
  selectAll(selectAll: boolean): void {
    this.dataManager.selectAll(selectAll);
  }

  // 获取数据总数
  getDataCount(): number {
    return this.dataManager.getCount();
  }
}
