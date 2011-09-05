package mew.modules {
	import mew.factory.ButtonFactory;
	import flash.events.Event;
	import fl.data.DataProvider;
	import fl.controls.ComboBox;
	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author abellee
	 */
	public class TimeSettor extends UISprite {
		
		private var timeSetBackground : Sprite;
		private var yearText : ComboBox;
		private var monthSelector:ComboBox;
		private var dateSelector:ComboBox;
		private var hourSelector:ComboBox;
		private var minuteSelector:ComboBox;
		private var dateList:Object;
		private var yearData:DataProvider;
		private var monthData:DataProvider;
		private var dateData:DataProvider;
		
		public function TimeSettor() {
			super();
			
			init();
		}
		private function init():void
		{
			timeSetBackground = MewSystem.getRoundRect(220, 100, 0x000000, 0xd1cfcc, 1.0, 1, .3);
			addChild(timeSetBackground);
			timeSetBackground.mouseChildren = false;
			timeSetBackground.mouseEnabled = false;
			timeSetBackground.x = 0;
			timeSetBackground.y = 0;
			
			dateList = {};
			var now:Date = new Date();
			var year:int = now.getFullYear();
			var month:int = now.getMonth() + 1;
			var date:int = now.getDate();
			var hour:int = now.getHours();
			var minute:int = now.getMinutes();
			
			dateList["year"] = [year];
			dateList["month" + year] = [month];
			dateList["date" + month] = [date];
			
			var nowTime:Number = new Date(year, month - 1, date, 0, 0, 0, 0).time;
			for (var i : int = 0; i < 7; i++) {
				nowTime += 86400000;
				var newDate:Date = new Date(nowTime);
				var newYear:Number = newDate.getFullYear();
				var newMonth:Number = newDate.getMonth() + 1;
				var newDay:Number = newDate.getDate();
				if(newYear == year){
					var curMonth:int = dateList["month" + year][dateList["month" + year].length - 1];
					if(newMonth != curMonth){
						dateList["month" + year].push(newMonth);
						if(!dateList["date" + newMonth]) dateList["date" + newMonth] = [];
						dateList["date" + newMonth].push(newDay);
					}else{
						dateList["date" + curMonth].push(newDay);
					}
				}else{
					dateList["year"].push(newYear);
					if(!dateList["month" + newYear]) dateList["month" + newYear] = [];
					if(!dateList["date" + newMonth]) dateList["date" + newMonth] = [];
					if(newMonth != dateList["month" + newYear][dateList["month" + newYear].length - 1])dateList["month" + newYear].push(newMonth);
					dateList["date" + newMonth].push(newDay);
				}
			}
			yearText = ButtonFactory.TimingComboBox();
			yearText.setStyle("textFormat", Widget.normalFormat);
			yearData = new DataProvider();
			for each (var ya : int in dateList["year"]) yearData.addItem({label:ya, data:ya});
			yearText.dataProvider = yearData;
			yearText.setSize(60, yearText.height);
			addChild(yearText);
			yearText.selectedIndex = 0;
			yearText.x = timeSetBackground.x + 10;
			yearText.y = timeSetBackground.y + 10;
			
			var lineText0:TextField = getLineText();
			addChild(lineText0);
			lineText0.x = yearText.x + yearText.width + 10;
			lineText0.y = yearText.y + (yearText.height - lineText0.height) / 2;
			
			monthSelector = ButtonFactory.TimingComboBox();
			monthSelector.setSize(50, monthSelector.height);
			addChild(monthSelector);
			monthSelector.x = lineText0.x + lineText0.width + 5;
			monthSelector.y = yearText.y;
			
			var lineText1:TextField = getLineText();
			addChild(lineText1);
			lineText1.x = monthSelector.x + monthSelector.width + 5;
			lineText1.y = monthSelector.y + (monthSelector.height - lineText1.height) / 2;
			
			dateSelector = ButtonFactory.TimingComboBox();
			dateSelector.setSize(50, dateSelector.height);
			addChild(dateSelector);
			dateSelector.x = lineText1.x + lineText1.width + 5;
			dateSelector.y = yearText.y;
			
			initMonthDataProvider(year);
			monthSelector.selectedIndex = getSelectIndex(month, monthData);
			dateSelector.selectedIndex = getSelectIndex(date, dateData);
			
			hourSelector = ButtonFactory.TimingComboBox();
			var str:String = "";
			var hourData : DataProvider = new DataProvider();
			for (var h : int = 0; h < 24; h++) {
				str = h < 10 ? "0" + h : h + "";
				hourData.addItem({label: str, data: h});
			}
			hourSelector.dataProvider = hourData;
			hourSelector.selectedIndex = hour;
			addChild(hourSelector);
			hourSelector.x = yearText.x;
			hourSelector.y = yearText.y + yearText.height + 10;
			
			var colonText:TextField = getColonText();
			addChild(colonText);
			
			hourSelector.setSize((timeSetBackground.width - 20) / 2 - colonText.width / 2 - 5, hourSelector.height);
			colonText.x = hourSelector.x + hourSelector.width + 5;
			colonText.y = hourSelector.y + (hourSelector.height - colonText.height) / 2;
			
			minuteSelector = ButtonFactory.TimingComboBox();
			var minuteData : DataProvider = new DataProvider();
			for (var r : int = 0; r < 60; r++) {
				str = r < 10 ? "0" + r : r + "";
				minuteData.addItem({label: str, data: r});
			}
			minuteSelector.dataProvider = minuteData;
			minuteSelector.selectedIndex = minute;
			addChild(minuteSelector);
			minuteSelector.x = colonText.x + colonText.width + 10;
			minuteSelector.y = hourSelector.y;
			
			minuteSelector.setSize(timeSetBackground.width - 10 - minuteSelector.x, minuteSelector.height);
			
			monthSelector.addEventListener(Event.CHANGE, monthChanged);
		}
		
		private function monthChanged(event:Event):void
		{
			initDateDataProvider(monthSelector.selectedItem.data);
		}
		
		private function initMonthDataProvider(year:int):void
		{
			monthData = new DataProvider();
			for each (var m : int in dateList["month" + year]) {
				var str:String = m < 10 ? "0" + m : m + "";
				monthData.addItem({label: str, data: m});
			}
			monthSelector.dataProvider = monthData;
			initDateDataProvider(dateList["month" + year][0]);
		}
		
		private function initDateDataProvider(month:int):void
		{
			dateData = new DataProvider();
			for each (var d : int in dateList["date" + month]) {
				var str:String = d < 10 ? "0" + d : d + "";
				dateData.addItem({label: str, data: d});
			}
			dateSelector.dataProvider = dateData;
		}
		
		private function getSelectIndex(value:int, dp:DataProvider):int
		{
			var len:int = dp.length;
			for (var j : int = 0; j < len; j++) {
				var obj:Object = dp.getItemAt(j);
				if(obj.data == value){
					return j;
				}
			}
			return 0;
		}
		
		private function getLineText():TextField
		{
			var textField:TextField = new TextField();
			textField.defaultTextFormat = Widget.normalFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = "-";
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.width = textField.textWidth;
			textField.height = textField.textHeight;
			return textField;
		}
		
		private function getColonText():TextField
		{
			var textField:TextField = new TextField();
			textField.defaultTextFormat = Widget.normalFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = ":";
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.width = textField.textWidth;
			textField.height = textField.textHeight;
			return textField;
		}
		
		public function get year():int
		{
			return yearText.selectedItem.data;
		}
		
		public function get month():int
		{
			return monthSelector.selectedItem.data;
		}
		
		public function get date():int
		{
			return dateSelector.selectedItem.data;
		}
		
		public function get hour():int
		{
			return hourSelector.selectedItem.data;
		}
		
		public function get minute():int
		{
			return minuteSelector.selectedItem.data;
		}
	}
}
