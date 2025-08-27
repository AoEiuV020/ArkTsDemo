// 定义列表项数据结构
export interface ListItem {
  id: number;
  title: string;
  description: string;
}

// 列表项数据模型类
export class ListItemModel implements ListItem {
  id: number;
  title: string;
  description: string;

  constructor(id: number, title: string, description: string) {
    this.id = id;
    this.title = title;
    this.description = description;
  }

  // 转换为普通对象
  toObject(): ListItem {
    return {
      id: this.id,
      title: this.title,
      description: this.description
    };
  }
}
