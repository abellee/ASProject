package mew.modules {
	import mew.factory.ButtonFactory;
	import fl.controls.Button;

	import mew.factory.StaticAssets;

	import resource.Resource;

	import widget.Widget;

	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class UploadImageViewer extends UISprite
	{
		private var defaultBackground:DisplayObject = null;
		private var tip:TextField = null;
		private var fileFilter:FileFilter = new FileFilter("Images(*.jpg, *.jpeg, *.png, *.gif, *.bmp)","*.jpg;*.jpeg;*.png;*.gif;*.bmp");
		private var file:File = null;
		private var bk:Sprite = null;
		private var clearButton:Button = null;
		public function UploadImageViewer(value:int = 180)
		{
			super();
			
			init(value);
		}
		private function init(value:int):void
		{
			var num:int = 50;
			drawImageBackground(value + 20, value + num);
			addChild(bk);
			
			if(value == 50) defaultBackground = new (Resource.MewDefault50)();
			else{
				defaultBackground = new (Resource.MewDefault180)();
				defaultBackground.width = value;
				defaultBackground.height = value;
			}
			addChild(defaultBackground);
			defaultBackground.x = (this.width - defaultBackground.width) / 2;
			defaultBackground.y = 10;
			
			tip = new TextField();
			tip.defaultTextFormat = new TextFormat(Widget.systemFont, 13, 0x4c4c4c, true);
			tip.autoSize = TextFieldAutoSize.LEFT;
			tip.text = "点击插入图片";
			tip.width = tip.textWidth;
			tip.height = tip.textHeight;
			tip.selectable = false;
			tip.mouseEnabled = false;
			addChild(tip);
			tip.x = (this.width - tip.width) / 2;
			tip.y = defaultBackground.y + defaultBackground.height + 10;
			
			addEventListener(MouseEvent.CLICK, browseImage);
			
			clearButton = ButtonFactory.CloseButton();
			addChild(clearButton);
			clearButton.visible = false;
			clearButton.x = defaultBackground.x + defaultBackground.width - clearButton.width / 2;
			clearButton.y = defaultBackground.y - clearButton.height / 2;
			clearButton.addEventListener(MouseEvent.CLICK, clearBitmap);
		}

		private function clearBitmap(event : MouseEvent) : void
		{
			reset();
		}
		
		private function browseImage(event:Event):void
		{
			if(event.target == clearButton) return;
			if(!file) file = new File();
			file.addEventListener(Event.SELECT, onSelectHandler);
			file.addEventListener(Event.COMPLETE, onCompleteHandler);
			file.addEventListener(Event.CANCEL, onCancelHandler);
			file.browse([fileFilter]);
		}
		
		private function onSelectHandler(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelectHandler);
			file.load();
		}
		
		private function onCompleteHandler(event:Event):void
		{
			file.removeEventListener(Event.COMPLETE, onCompleteHandler);
			var ba:ByteArray = file.data;
			var loader:Loader = new Loader();
			var func:Function = function(event:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, func);
				var bitmap:Bitmap = event.target.content as Bitmap;
				clearChildren();
				if(bitmap.height > 7000){
					var alertText:TextField = new TextField();
					alertText.defaultTextFormat = new TextFormat(Widget.systemFont, 16, 0x4c4c4c, true, null, null, null, null, null, null, null, null, 5);
					alertText.wordWrap = true;
					alertText.width = bk.width - 20;
					alertText.selectable = false;
					alertText.mouseEnabled = false;
					alertText.mouseWheelEnabled = false;
					alertText.text = "图片尺寸过大，无法显示缩略图！但不影响上传！";
					addChild(alertText);
					alertText.x = (bk.width - alertText.textWidth) / 2;
					alertText.y = (bk.height - alertText.textHeight) / 2;
					addChild(clearButton);
					clearButton.visible = true;
					return;
				}
				var scale:Number = 1;
				var w:int = bk.width - 20;
				var h:int = bk.height - 20;
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
				bitmap.alpha = 0;
				addChild(bitmap);
				bitmap.x = (bk.width - bitmap.width) / 2;
				bitmap.y = (bk.height - bitmap.height) / 2;
				TweenLite.to(bitmap, .5, {alpha: 1});
				addChild(clearButton);
				clearButton.visible = true;
				return;
			};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, func);
			loader.loadBytes(ba);
		}
		
		private function clearChildren():void
		{
			var child:DisplayObject = this.getChildAt(3);
			removeChild(child);
			defaultBackground.alpha = 0;
			tip.alpha = 0;
		}
		
		public function reset():void
		{
			clearChildren();
			
			defaultBackground.alpha = 0;
			tip.alpha = 0;
			TweenLite.to(defaultBackground, .3, {alpha: 1});
			TweenLite.to(tip, .3, {alpha: 1});
			
			if(file){
				file.removeEventListener(Event.SELECT, onSelectHandler);
				file.removeEventListener(Event.COMPLETE, onCompleteHandler);
				file.removeEventListener(Event.CANCEL, onCancelHandler);
				file = null;
			}
			clearButton.visible = false;
		}
		
		public function get byteArray():ByteArray
		{
			if(!file) return null;
			return file.data;
		}
		
		public function get imageExtension():String
		{
			if(!file) return null;
			return file.extension;
		}
		
		public function get imageFile():File
		{
			return file;
		}
		
		private function onCancelHandler(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelectHandler);
			file.removeEventListener(Event.COMPLETE, onCompleteHandler);
			file.removeEventListener(Event.CANCEL, onCancelHandler);
		}
		
		private function drawImageBackground(w:int, h:int):void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .2);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRect(0, 0, w, h);
			bk.graphics.endFill();
			bk.mouseChildren = false;
			bk.mouseEnabled = false;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			defaultBackground = null;
			tip = null;
			fileFilter = null;
			if(file){
				file.removeEventListener(Event.SELECT, onSelectHandler);
				file.removeEventListener(Event.COMPLETE, onCompleteHandler);
				file.removeEventListener(Event.CANCEL, onCancelHandler);
			}
			file = null;
			bk = null;
			if(clearButton){
				clearButton.removeEventListener(MouseEvent.CLICK, clearBitmap);
				clearButton = null;
			}
		}
	}
}