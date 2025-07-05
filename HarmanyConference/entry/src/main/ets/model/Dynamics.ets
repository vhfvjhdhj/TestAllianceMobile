export interface DynamicsData {
  dynamicId: number;//动态号
  publisherId: number;//发布者编号
  title: string;//题目
  content: string;//动态内容
  summary: string;//简介
  author: string;//作者
  imageUrl: string;//动态相关图片
  createTime: string;//创建时间
  auditStatus:number;//审核状态
}

export default class Dynamics {
  dynamicId: number = 0;//动态号
  publisherId: number = 0;//发布者编号
  title: string = "";//题目
  content: string = "";//动态内容
  summary: string = "";//简介
  author: string = "";//作者
  imageUrl: string = "";//动态相关图片
  createTime: string = "";//创建时间
  auditStatus:number = 0;

  constructor(
    dynamicId: number,
    publisherId: number,
    title: string,
    content: string,
    summary: string,
    author: string,
    imageUrl: string,
    createTime: string,
    auditStatus:number
  ){
    this.dynamicId = dynamicId;
    this.publisherId = publisherId;
    this.title = title;
    this.content = content;
    this.summary = summary;
    this.author = author;
    this.imageUrl = imageUrl;
    this.createTime = createTime;
    this.auditStatus = auditStatus;
  }

  // 时间格式化方法
  private formatTime(timeString: string): string {
    const timePart = timeString.split(" ")[1];
    return timePart.substring(0, 5);
  }
  get formattedStartTime(): string {
    return this.formatTime(this.createTime);
  }
  get date(): string {
    return this.createTime.split(" ")[0];
  }
  get datePart(): string {
    return this.createTime.split(" ")[0] || "";
  }
}



