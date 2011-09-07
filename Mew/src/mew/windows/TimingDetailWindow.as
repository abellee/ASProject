package mew.windows {
	import mew.events.MewEvent;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;

	import mew.data.TimingWeiboVariable;
	import mew.factory.ButtonFactory;
	import mew.modules.IWeiboPublish;

	import resource.Resource;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;
	import com.iabel.util.DashLine;
	import com.iabel.utils.ScaleBitmap;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	/**
	 * @author Abel Lee
	 */
	public class TimingDetailWindow extends UISprite implements IWeiboPublish {
		private var detailText:TextField = null;
		private var timeText:TextField = null;
		private var deleteButton:Button = null;
		private var postNow:Button = null;
		private var background:Sprite = null;
		private var whiteBK:Sprite = null;
		private var triangle:Sprite = null;
		private var _data:TimingWeiboVariable = null;
		private var scrollPane:ScrollPane = null;
		private var scrollBarSkin:Bitmap = null;
		private var contentContainer:Sprite = new Sprite();
		private var file:File = null;
		private var dashLine:Bitmap = null;
		private var closeButton:Button = null;
		private var imageContainer:Sprite = null;
		public function TimingDetailWindow(value:TimingWeiboVariable) {
			_data = value;
			init();
		}
		protected function init():void
		{
			drawRectRoundBackground(300, 200);
			triangle = MewSystem.getTriangle("down", 50);
			addChild(triangle);
			triangle.x = (background.width - triangle.width) / 2;
			triangle.y = background.height - triangle.height / 2;
			drawWhiteBackground(290, 190);
			Widget.widgetGlowFilter(this);
			addChild(whiteBK);
			whiteBK.x = 5;
			whiteBK.y = 5;
			
			timeText = new TextField();
			timeText.defaultTextFormat = Widget.usernameFormat;
			timeText.autoSize = TextFieldAutoSize.LEFT;
			timeText.selectable = false;
			timeText.mouseEnabled = false;
			var time:Number = _data.time;
			var date:Date = new Date(time);
			var year:Number = date.getFullYear();
			var month:Number = date.getMonth() + 1;
			var day:Number = date.getDate();
			var hour:Number = date.getHours();
			var minute:Number = date.getMinutes();
			
			var monthStr:String = month < 10 ? "0" + month : month + "";
			var dayStr:String = day < 10 ? "0" + day : day + "";
			var hourStr:String = hour < 10 ? "0" + hour : hour + "";
			var minuteStr:String = minute < 10 ? "0" + minute : minute + "";
			timeText.text = year + " - " + monthStr + " - " + dayStr + "    " + hourStr + " : " + minuteStr;
			timeText.width = timeText.textWidth;
			timeText.height = timeText.textHeight;
			addChild(timeText);
			timeText.x = whiteBK.x + 10;
			timeText.y = whiteBK.y + 10;
			
			var dl:DashLine = new DashLine(whiteBK.width, 1);
			dl.drawDashLine(4, 0xaa000000, 2);
			dashLine = new Bitmap(dl);
			addChild(dashLine);
			dashLine.x = whiteBK.x;
			dashLine.y = timeText.y + timeText.height + 5;
			
			closeButton = ButtonFactory.CloseButton();
			addChild(closeButton);
			closeButton.x = whiteBK.x + whiteBK.width - closeButton.width - 10;
			closeButton.y = timeText.y;
			closeButton.addEventListener(MouseEvent.CLICK, closeDetailWindow);
			
			detailText = new TextField();
			detailText.defaultTextFormat = Widget.wbTextFormat;
			detailText.autoSize = TextFieldAutoSize.LEFT;
			detailText.wordWrap = true;
			detailText.text = _data.content;
			detailText.width = whiteBK.width - 40;
			detailText.height = detailText.textHeight;
			contentContainer.addChild(detailText);
			
			scrollPane = new ScrollPane();
			scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(scrollPane);
			scrollPane.move(timeText.x, timeText.y + timeText.height + 10);
			scrollPane.setSize(whiteBK.width - 20, whiteBK.height - timeText.y - timeText.height - 50);
			scrollPane.source = contentContainer;
			scrollPane.setStyle("upSkin", getSprite(scrollPane.width, scrollPane.height));
			scrollBarSkin = new ScaleBitmap((new Resource.ScrollBarSkin() as Bitmap).bitmapData, "auto", true);
			scrollBarSkin.scale9Grid = new Rectangle(0, 10, 16, 10);
			scrollPane.setStyle("thumbUpSkin", scrollBarSkin);
			scrollPane.setStyle("thumbOverSkin", scrollBarSkin);
			scrollPane.setStyle("thumbDownSkin", scrollBarSkin);
			scrollPane.setStyle("thumbIcon", new Sprite());
			scrollPane.setStyle("trackUpSkin", new Sprite());
			scrollPane.setStyle("trackOverSkin", new Sprite());
			scrollPane.setStyle("trackDownSkin", new Sprite());
			scrollPane.setStyle("upArrowUpSkin", new Sprite());
			scrollPane.setStyle("upArrowOverSkin", new Sprite());
			scrollPane.setStyle("upArrowDownSkin", new Sprite());
			scrollPane.setStyle("downArrowUpSkin", new Sprite());
			scrollPane.setStyle("downArrowOverSkin", new Sprite());
			scrollPane.setStyle("downArrowDownSkin", new Sprite());
			
			deleteButton = ButtonFactory.OrangeButton();
			deleteButton.setStyle("textFormat", Widget.usernameFormat);
			deleteButton.width = 60;
			deleteButton.height = 30;
			deleteButton.label = "删 除";
			addChild(deleteButton);
			deleteButton.x = scrollPane.width - deleteButton.width + scrollPane.x;
			deleteButton.y = scrollPane.y + scrollPane.height + 10;
			deleteButton.addEventListener(MouseEvent.CLICK, deleteTimingWeibo);
			
			postNow = ButtonFactory.OrangeButton();
			postNow.setStyle("textFormat", Widget.usernameFormat);
			postNow.width = 100;
			postNow.height = 30;
			postNow.label = "立即发布";
			addChild(postNow);
			postNow.addEventListener(MouseEvent.CLICK, sendRightNow);
			postNow.x = deleteButton.x - postNow.width - 10;
			postNow.y = scrollPane.y + scrollPane.height + 10;
			
			if(_data && _data.img != ""){
				trace(_data.img);
				file = File.applicationStorageDirectory.resolvePath("timing/" + _data.img);
				file.addEventListener(Event.COMPLETE, onFileLoadComplete);
				file.load();
			}
		}
		
		private function deleteTimingWeibo(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.DELETE));
		}

		private function sendRightNow(event : MouseEvent) : void
		{
			var ba:ByteArray = null;
			if(file) ba = file.data;
			this.mouseChildren = false;
			MewSystem.showCycleLoading(this);
			MewSystem.app.alternationCenter.updateStatus(_data.content, ba, "", this as IWeiboPublish);
		}
		
		public function updateSuccess():void
		{
			MewSystem.showLightAlert("微博发布成功!", this);
			this.mouseChildren = true;
			MewSystem.removeCycleLoading(this);
		}
		
		public function updateFailed():void
		{
			MewSystem.showLightAlert("微博发布失败!", this);
			this.mouseChildren = true;
			MewSystem.removeCycleLoading(this);
		}

		private function closeDetailWindow(event : MouseEvent) : void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		private function onFileLoadComplete(event : Event) : void
		{
			file.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			var loader:Loader = new Loader();
			var func:Function = function(event:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, func);
				if(!imageContainer) imageContainer = new Sprite();
				var bitmap:Bitmap = event.target.content as Bitmap;
				if(bitmap.height > 7000){
					var alertText:TextField = new TextField();
					alertText.defaultTextFormat = new TextFormat(Widget.systemFont, 16, 0x4c4c4c, true, null, null, null, null, null, null, null, null, 5);
					alertText.wordWrap = true;
					alertText.width = 180;
					alertText.height = alertText.textHeight;
					alertText.selectable = false;
					alertText.mouseEnabled = false;
					alertText.mouseWheelEnabled = false;
					alertText.text = "图片尺寸过大，无法显示缩略图！但不影响上传！";
					imageContainer.addChild(alertText);
					imageContainer.width = alertText.width;
					imageContainer.height = alertText.height;
					contentContainer.addChild(imageContainer);
					alertText.y = detailText.y + detailText.height + 5;
					scrollPane.update();
					scrollPane.drawNow();
					return;
				}
				var scale:Number = 1;
				var w:int = 180;
				var h:int = 180;
				if(bitmap.width >= bitmap.height && bitmap.width >= w){
					scale = w / bitmap.width;
				}else if(bitmap.width < bitmap.height && bitmap.height >= h){
					scale = h / bitmap.height;
				}
				bitmap.width = int(bitmap.width * scale);
				bitmap.height = int(bitmap.height * scale);
				while(bitmap.width > w || bitmap.height > h){
					if(bitmap.width >= w){
						scale = w / bitmap.width;
					}else if(bitmap.height >= h){
						scale = h / bitmap.height;
					}
					bitmap.width = int(bitmap.width * scale);
					bitmap.height = int(bitmap.height * scale);
				}
				bitmap.x = (180 - bitmap.width) / 2;
				bitmap.y = (180 - bitmap.height) / 2;
				imageContainer.addChild(bitmap);
				imageContainer.width = bitmap.width;
				imageContainer.height = bitmap.height;
				imageContainer.addChild(bitmap);
				contentContainer.addChild(imageContainer);
				bitmap.y = detailText.y + detailText.height + 5;
				scrollPane.update();
				scrollPane.drawNow();
			};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, func);
			loader.loadBytes(file.data);
		}
		
		protected function getSprite(w:int, h:int):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000, 0);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			return sp;
		}

		private function drawWhiteBackground(w : int, h : int) : void
		{
			if(!whiteBK) whiteBK = new Sprite();
			whiteBK.graphics.beginFill(0xFFFFFF, 1.0);
			whiteBK.graphics.drawRoundRect(0, 0, w, h, 12);
			whiteBK.graphics.endFill();
		}
		
		public function moveTriangleRight():int
		{
			var originPos:int = triangle.x;
			triangle.x = background.width - triangle.width;
			return triangle.x - originPos;
		}
		
		public function moveTriangleLeft():int
		{
			var originPos:int = triangle.x;
			triangle.x = 5;
			return triangle.x - originPos;
		}
		
		private function drawRectRoundBackground(w:int, h:int):void
		{
			if(!background) background = new Sprite();
			background.graphics.beginFill(Widget.mainColor, 1.0);
			background.graphics.drawRoundRect(0, 0, w, h, 12);
			background.graphics.endFill();
			addChild(background);
		}
		
		public function get data() : TimingWeiboVariable {
			return _data;
		}

		public function set data(data : TimingWeiboVariable) : void {
			_data = data;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(scrollBarSkin) scrollBarSkin.bitmapData.dispose();
			if(dashLine) dashLine.bitmapData.dispose();
			if(closeButton) closeButton.removeEventListener(MouseEvent.CLICK, closeDetailWindow);
			if(deleteButton) deleteButton.removeEventListener(MouseEvent.CLICK, deleteTimingWeibo);
			if(postNow) postNow.removeEventListener(MouseEvent.CLICK, sendRightNow);
			if(file) file.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			
			detailText = null;
			timeText = null;
			deleteButton = null;
			postNow = null;
			background = null;
			whiteBK = null;
			triangle = null;
			_data = null;
			scrollPane = null;
			scrollBarSkin = null;
			contentContainer = null;
			file = null;
			dashLine = null;
			closeButton = null;
			imageContainer = null;
		}
	}
}
