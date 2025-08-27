import { ListItemModel } from '../models/ListItemModel';

// 测试数据工厂类
export class TestDataFactory {
  // 生成基础测试数据
  static generateBasicTestData(): ListItemModel[] {
    const data: ListItemModel[] = [];
    for (let i = 1; i <= 10; i++) {
      data.push(new ListItemModel(
        i,
        `项目${TestDataFactory.numberToChinese(i)}`,
        `这是第${TestDataFactory.numberToChinese(i)}个列表项的描述`
      ));
    }
    return data;
  }

  // 生成大量测试数据（用于懒加载）
  static generateLargeTestData(startIndex: number = 1, count: number = 100): ListItemModel[] {
    const data: ListItemModel[] = [];
    for (let i = startIndex; i < startIndex + count; i++) {
      data.push(new ListItemModel(
        i,
        `懒加载项目 ${i}`,
        `这是第 ${i} 个懒加载列表项的描述，包含更多的内容用于测试长文本显示效果`
      ));
    }
    return data;
  }

  // 模拟分页数据加载
  static generatePageData(page: number, pageSize: number = 20): ListItemModel[] {
    const startIndex = (page - 1) * pageSize + 1;
    const data: ListItemModel[] = [];

    for (let i = startIndex; i < startIndex + pageSize; i++) {
      data.push(new ListItemModel(
        i,
        `分页项目 ${i}`,
        `第 ${page} 页，第 ${i} 个项目的描述信息`
      ));
    }
    return data;
  }

  // 生成随机数据
  static generateRandomData(count: number): ListItemModel[] {
    const titles = ['任务', '项目', '工作', '计划', '目标', '活动', '事件', '议程'];
    const descriptions = [
      '这是一个重要的描述信息',
      '包含详细的说明和要求',
      '需要特别注意的关键内容',
      '具有重要意义的项目描述',
      '详细的功能说明和使用指南'
    ];

    const data: ListItemModel[] = [];
    for (let i = 1; i <= count; i++) {
      const randomTitle = titles[Math.floor(Math.random() * titles.length)];
      const randomDesc = descriptions[Math.floor(Math.random() * descriptions.length)];

      data.push(new ListItemModel(
        i,
        `${randomTitle} ${i}`,
        `${randomDesc} - ${i}`
      ));
    }
    return data;
  }

  // 数字转中文
  private static numberToChinese(num: number): string {
    const chineseNumbers = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    if (num <= 10) {
      return chineseNumbers[num];
    }
    return num.toString();
  }
}
