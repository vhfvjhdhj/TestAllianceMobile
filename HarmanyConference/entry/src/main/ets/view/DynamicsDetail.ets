import { DynamicState } from "../model/DynamicState";
import Dynamics from "../model/Dynamics";
import { http } from "@kit.NetworkKit";
import { NetworkImage } from "../util/NetworkImage";

@Entry
@Component
export struct DynamicsDetail {
  @State dynamic: Dynamics | null = null;

  private dynamicState = DynamicState.getInstance();

  async recordVisit() {
    if (!this.dynamic || !this.dynamic.dynamicId) {
      console.error("动态数据无效，缺少dynamic_id");
      return;
    }

    const user_id = this.dynamicState.getCurrentUserId();
    if (!user_id) {
      console.log("用户未登录，不记录浏览");
      return;
    }

    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'http://172.22.123.162:8080/recordVisit',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({
            user_id: user_id,
            dynamic_id: this.dynamic.dynamicId,
            visitTime: new Date().toISOString() // 添加当前时间
          })
        }
      );

      if (response.responseCode === 200) {
        console.log("访问记录成功");
      } else {
        console.error("记录访问失败:", response.responseCode);
      }

      httpRequest.destroy();
    } catch (error) {
      console.error('记录访问失败:', JSON.stringify(error));
    }
  }


  aboutToAppear() {
    this.dynamic = DynamicState.getInstance().selectedDynamics;
    console.log("加载的动态:", this.dynamic);
    this.recordVisit();

  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column }) {
        // 导航标题
        Row() {
          Text("动态详情")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 16 });
        }
        .width("100%")
        .padding(10)
        .backgroundColor("#F1F3F5");

        Scroll() {
          Column({ space: 10 }) {
            if (this.dynamic) {
              // 封面图

              NetworkImage({ url: this.dynamic.imageUrl })

                .width("100%")
                .height(200)
                .borderRadius(12)
                .margin({ bottom: 12 });

              // 动态标题与作者
              Text(this.dynamic.title)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 4 });

              Text(`作者：${this.dynamic.author}`)
                .fontSize(16)
                .fontColor(Color.Gray);

              // 发布时间
              Text(`发布时间：${this.dynamic.date}`)
                .fontSize(16)
                .fontColor(Color.Gray);

              // 动态内容
              Text("内容详情")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 10, bottom: 4 });

              Text(this.dynamic.content)
                .fontSize(15)
                .lineHeight(22);

            } else {
              // 加载状态
              Column() {
                Progress({
                  value: 0,
                  total: 100,
                  type: ProgressType.Linear,
                })
                  .width(200)
                  .height(4)
                  .color(Color.Blue);
                Text("加载中...").margin({ top: 8 });
              }
              .width("100%")
              .height(200)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center);
            }
          }
          .padding(16)
          .width("100%");
        }
        .layoutWeight(1)
        .width("100%");
      }
      .width("100%")
      .height("100%");
    }
    .hideTitleBar(true)
  }
}