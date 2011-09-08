package mew.modules
{
	import com.iabel.core.UISprite;
	
	import config.Config;
	
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class URLShortor extends UISprite
	{
		private var bk:Sprite = null;
		private var textInput:TextField = null;
		private var tipText:TextField = null;
		private var enterButton:Button = null;
		private var shortURL:String = "http://api.t.sina.com.cn/short_url/shorten.xml";
		private var urlLoader:URLLoader = null;
		public var originStr:String = null;
		public var parentStage:UISprite = null;
		public function URLShortor()
		{
			super();
			
			init();
		}
		private function init():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, 300, 50, 12, 12);
			bk.graphics.endFill();
			
			Widget.widgetGlowFilter(bk);
			
			addChild(bk);
			bk.x = 10;
			bk.y = 10;
			
			if(!textInput) textInput = new TextField();
			textInput.defaultTextFormat = Widget.normalFormat;
			textInput.width = 220;
			textInput.height = 22;
			textInput.border = true;
			textInput.borderColor = 0x4c4c4c;
			textInput.type = TextFieldType.INPUT;
			addChild(textInput);
			textInput.x = bk.x + 10;
			textInput.y = bk.y + 10;
			textInput.addEventListener(Event.ADDED_TO_STAGE, textInput_onAddedToStage);
			
			if(!enterButton) enterButton = ButtonFactory.WhiteButton();
			enterButton.label = "确 定";
			enterButton.width = 60;
			addChild(enterButton);
			enterButton.x = textInput.x + textInput.width + 5;
			enterButton.y = textInput.y;
			enterButton.addEventListener(MouseEvent.CLICK, enterButton_mouseClickHandler);
			
			if(!tipText) tipText = new TextField();
			tipText.defaultTextFormat = Widget.tipFormat;
			tipText.autoSize = TextFieldAutoSize.LEFT;
			addChild(tipText);
			tipText.selectable = false;
			tipText.x = textInput.x;
			tipText.y = textInput.y + textInput.height + 2;
			tipText.text = "请输入以 http:// 或者 https:// 开头的网址";
		}
		
		private function textInput_onAddedToStage(event:Event):void
		{
			this.stage.focus = textInput;
		}
		
		public function appendText(str:String):void
		{
			textInput.text = str;
			originStr = str;
			enterButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function getShortenURL():String
		{
			return textInput.text;
		}
		
		private function enterButton_mouseClickHandler(event:MouseEvent):void
		{
			var urlPattern:RegExp = /(http|https):\/\/[a-zA-Z.-\d\/\#\?\&\=]+/;
			if(!urlPattern.test(textInput.text)){
				MewSystem.showLightAlert("您输入的网址不合法!", parentStage);
				return;
			}
			this.mouseChildren = false;
			MewSystem.showCycleLoading(this);
			if(!urlLoader) urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, shortURLComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, shortURLonError);
			urlLoader.load(new URLRequest(shortURL + "?source=" + Config.appKey + "&url_long=" + textInput.text));
		}
		
		private function shortURLonError(event:IOErrorEvent):void
		{
			if(this.contains(MewSystem.cycleMotion)) removeChild(MewSystem.cycleMotion);
			this.mouseChildren = true;
			urlLoader.removeEventListener(Event.COMPLETE, shortURLComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, shortURLonError);
			MewSystem.showLightAlert("网址缩短失败！", parentStage);
		}
		
		private function shortURLComplete(event:Event):void
		{
			if(this.contains(MewSystem.cycleMotion)) removeChild(MewSystem.cycleMotion);
			this.mouseChildren = true;
			urlLoader.removeEventListener(Event.COMPLETE, shortURLComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, shortURLonError);
			var xml:XML = XML(event.target.data);
			if(xml && xml.url.url_short) textInput.text = xml.url.url_short;
			this.dispatchEvent(new MewEvent(MewEvent.SHORTEN_URL_SUCCESS));
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			textInput.removeEventListener(Event.ADDED_TO_STAGE, textInput_onAddedToStage);
			enterButton.removeEventListener(MouseEvent.CLICK, enterButton_mouseClickHandler);
			
			if(urlLoader){
				urlLoader.removeEventListener(Event.COMPLETE, shortURLComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, shortURLonError);
			}
			bk = null;
			textInput = null;
			tipText = null;
			enterButton = null;
			shortURL = null;
			urlLoader = null;
			originStr = null;
			parentStage = null;
		}
	}
}