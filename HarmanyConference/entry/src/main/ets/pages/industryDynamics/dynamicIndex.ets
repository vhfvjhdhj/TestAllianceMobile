import { DynamicsData } from '../../model/Dynamics';
import Dynamics from '../../model/Dynamics';
import { bufferToString } from '../../util/BufferUtil';
import { DynamicState } from '../../model/DynamicState';
import { DynamicItem } from '../../view/DynamicItem';
import { http } from "@kit.NetworkKit";

@Component
export struct dynamicIndex {
  @Consume("DynamicsPageStack") private pageStack!: NavPathStack;
  @State message: string = "动态通知";
  @State dynamicList: Dynamics[] = [];      // 动态数据列表
  @State filteredList: Dynamics[] = [];     // 搜索过滤后的列表
  @State isLoading: boolean = true;         // 加载状态
  @State errorMessage: string = '';         // 错误信息
  @State searchKeyword: string = '';        // 搜索关键词
  @State refreshing: boolean = false;       // 下拉刷新状态

  private handleDynamicClick = (dynamic: Dynamics) => {
    console.log("动态点击:", dynamic.title);
    DynamicState.getInstance().selectedDynamics = dynamic;
    this.pageStack.pushPath({ name: "DynamicsDetail" });
  };

  aboutToAppear(): void {
    this.loadDynamics();
  }

  async loadDynamics() {
    this.refreshing = true;

    try {
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        'http://172.22.123.162：8080/dynamics',
        { method: http.RequestMethod.GET }
      );

      if (response.responseCode === 200) {
        const rawData = response.result.toString();
        console.log("原始响应数据:", rawData);
        const jsonData: DynamicsData[] = JSON.parse(rawData);

        this.dynamicList = jsonData.map(
          (item) => new Dynamics(
            item.dynamicId, item.publisherId, item.title, item.content,
            item.summary, item.author, item.imageUrl, item.createTime, item.auditStatus
          )
        );

        this.filteredList = this.dynamicList.filter(d => d.auditStatus !== 0);
      } else {
        this.errorMessage = `获取数据失败: ${response.responseCode}`;
      }

      httpRequest.destroy();
    } catch (error) {
      console.error('加载动态失败:', JSON.stringify(error));
      this.errorMessage = '网络错误，无法加载动态';
    } finally {
      this.isLoading = false;
      this.refreshing = false;
    }
  }

  private onSearchChange(keyword: string) {
    this.searchKeyword = keyword;
    this.filteredList = this.dynamicList
      .filter(d => d.auditStatus !== 0)
      .filter(d => d.title.includes(keyword) || d.summary.includes(keyword));
  }

  build() {
    NavDestination() {
      Column() {
        // 顶部区域
        Column() {
          // 主标题区域
          Row() {
            Text('动态通知')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')

            Blank()
          }
          .width('100%')
          .padding({ bottom: 8 })

          // 搜索区域
          Row() {
            TextInput({ placeholder: "搜索动态名称" })
              .fontSize(14)
              .width('100%')
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .onChange((value: string) => this.onSearchChange(value));
          }
          .width('100%')
        }
        .width('100%')
        .padding({ top: 12, bottom: 12, left: 16, right: 16 })
        .backgroundColor('#ffffff')
        .borderRadius(12)

        // 内容区域
        if (this.isLoading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 100 })
        } else if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(16)
            .fontColor(Color.Red)
            .margin({ top: 50 })
        } else {
          Refresh({ refreshing: $$this.refreshing }) {
            List() {
              ForEach(this.filteredList, (dynamic: Dynamics) => {
                ListItem() {
                  DynamicItem({
                    dynamic: dynamic,
                    onItemClick1: this.handleDynamicClick
                  })
                }
              }, (dynamic: Dynamics) => dynamic.title)
            }
            .width('100%')
            .layoutWeight(1)
            .divider({ strokeWidth: 0.5, color: 0xEEEEEE })
            .edgeEffect(EdgeEffect.Spring)
            .backgroundColor('#F1F3F5')
          }
          .onRefreshing(() => {
            this.loadDynamics();
          })
          .backgroundColor(0xF1F3F5)
          .refreshOffset(64)
          .pullToRefresh(true)
        }
      }
      .backgroundColor('#F1F3F5')
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}