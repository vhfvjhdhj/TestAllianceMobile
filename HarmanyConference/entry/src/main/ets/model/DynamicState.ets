import Dynamics from "./Dynamics";


export class DynamicState {
  // 当前选中的课程
  private _selectedDynamics: Dynamics | null = null;

  get selectedDynamics(): Dynamics | null {
    return this._selectedDynamics;
  }
  set selectedDynamics(dynamics: Dynamics | null) {
    this._selectedDynamics = dynamics;
  }
  // 单例模式
  private static instance: DynamicState;
  static getInstance(): DynamicState {
    if (!DynamicState.instance) {
      DynamicState.instance = new DynamicState();
    }
    return DynamicState.instance;
  }
}