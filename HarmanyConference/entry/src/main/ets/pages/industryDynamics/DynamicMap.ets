import { bufferToString } from "../../util/BufferUtil";
import { DynamicsDetail } from "../../view/DynamicsDetail";
import { dynamicIndex } from "../../pages/industryDynamics/dynamicIndex";

@Component
export struct DynamicMap {
  @Consume("DynamicsPageStack") private dynamicPageStack!: NavPathStack;

  @Builder
  PageMap(name: string) {
    if (name === "dynamicIndex") {
      dynamicIndex()
    } else if (name === "DynamicsDetail") {
        DynamicsDetail()
    }
  }

  build() {
    Navigation(this.dynamicPageStack) {
      dynamicIndex() // 初始页面
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
    // .title("动态")
  }
}