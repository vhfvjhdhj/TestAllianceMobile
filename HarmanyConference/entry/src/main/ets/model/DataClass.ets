export class DataClass{
  data:number=0;
  isCurrentMonth:boolean=false;
  isToday:boolean=false;
  isSelected: boolean=false;
  date:Date=new Date();
  constructor(data:number,isCurrentMonth:boolean,isToday:boolean,isSelected:boolean,date:Date) {
    this.data=data;
    this.isCurrentMonth=isCurrentMonth;
    this.isToday=isToday;
    this.isSelected=isSelected;
    this.date=date;
  }
}