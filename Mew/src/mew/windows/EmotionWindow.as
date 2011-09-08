package mew.windows {
	import fl.controls.Button;

	import mew.factory.ButtonFactory;
	import mew.modules.EmotionItem;
	import mew.modules.IEmotionCorrelation;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextFormat;
	
	public class EmotionWindow extends ALNativeWindow
	{
		private var emotionTabs:Vector.<String> = null;
		private var emotionButtons:Vector.<Button> = null;
		private var leftButton:Button = null;
		private var rightButton:Button = null;
		private var buttonsContainer:Sprite = null;
		private var masker:Sprite = null;
		private var scrolling:Boolean = false;
		private var urlLoader:URLLoader = null;
		private var xmlData:XML = null;
		private var curPageXMLList:XMLList = null;
		private var emotionsContainer:UISprite = null;
		private var numPerPage:int = 48;
		private var pageNum:int = 1;
		private var curPage:int = 0;
		private var curTabs:String = "";
		private var pageButtons:Vector.<Button> = null;
		private var pageFlipperContainer:Sprite = null;
		
		public var targetWindow:IEmotionCorrelation = null;
		
		private var prePageFlipper:Button = null;
		private var preEmotionTab:Button = null;
		
		public function EmotionWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(300, 300);
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			
			emotionsContainer = new UISprite();
			pageFlipperContainer = new Sprite();
			pageFlipperContainer.mouseEnabled = false;
			buttonsContainer = new Sprite();
			masker = new Sprite();
			masker.scrollRect = new Rectangle(0, 0, 220, 30);
			
			emotionTabs = new <String>["默认", "心情", "爱心", "休闲", "搞怪", "管不着", "大耳兔", "哈皮兔", "天气", "星座", "小新小浪", "亚运会", "张小盒", "悠嘻猴", "蘑菇点点", "阿狸"];
			
			leftButton = ButtonFactory.ArrowButton();
			rightButton = ButtonFactory.ArrowButton(-1);
			addChild(leftButton);
			leftButton.x = 30;
			leftButton.y = 35;
			emotionButtons = new Vector.<Button>();
			for each(var str:String in emotionTabs){
				var btn:Button = ButtonFactory.WhiteButton();
				btn.setStyle("textFormat", new TextFormat(Widget.systemFont, 12, Widget.orangeButtonFontColor));
				btn.setStyle("disabledTextFormat", new TextFormat(Widget.systemFont, 12, Widget.orangeButtonFontColor));
				btn.label = str;
				btn.toggle = true;
				btn.width = 60;
				emotionButtons.push(btn);
				var num:int = buttonsContainer.numChildren;
				buttonsContainer.addChild(btn);
				btn.x = num * (btn.width + 5);
				btn.addEventListener(MouseEvent.CLICK, emotionTabs_mouseClickHandler);
			}
			emotionButtons.length = emotionTabs.length;
			emotionButtons.fixed = true;
			emotionButtons[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			preEmotionTab = emotionButtons[0];
			
			masker.addChild(buttonsContainer);
			addChild(masker);
			masker.x = leftButton.x + leftButton.width + 5;
			masker.y = leftButton.y - 5;
			
			addChild(rightButton);
			rightButton.x = masker.scrollRect.width + masker.x + 20;
			rightButton.y = leftButton.y;
			
			addChild(emotionsContainer);
			emotionsContainer.x = leftButton.x + 1;
			emotionsContainer.y = masker.y + masker.scrollRect.height + 5;
			
			leftButton.addEventListener(MouseEvent.CLICK, leftButton_mouseClickHandler);
			rightButton.addEventListener(MouseEvent.CLICK, rightButton_mouseClickHandler);
			
			addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		private function onDeactivate(event:Event):void
		{
			MewSystem.closeEmotionWindow();
		}
		
		public function orientationWindow(point:Point):void
		{
			this.stage.nativeWindow.x = point.x - this.stage.nativeWindow.width / 2;
			this.stage.nativeWindow.y = point.y - this.stage.nativeWindow.height;
			loadEmotions();
		}
		
		private function loadEmotions():void
		{
			if(!urlLoader) urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, emotionsXML_loadCompleteHandler);
			urlLoader.load(new URLRequest("config/emotions.xml"));
		}
		
		private function emotionsXML_loadCompleteHandler(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, emotionsXML_loadCompleteHandler);
			xmlData = XML(event.target.data);
			curPageXMLList = xmlData.emotion.(category == "");
			pageNum = Math.ceil(curPageXMLList.length() / numPerPage);
			listEmotions(0);
			showPageButton();
		}
		
		private function listEmotions(page:int):void
		{
			if(emotionsContainer.numChildren) emotionsContainer.removeAllChildren();
			var start:int = page * numPerPage;
			var end:int = (start + 1) * numPerPage; 
			for(var i:int = start; i < end; i++){
				var item:XML = curPageXMLList[i];
				if(!item) return;
				if(emotionsContainer.numChildren >= numPerPage) break;
				var emotionItem:EmotionItem = new EmotionItem();
				emotionItem.loadEmotion(item.url, item.phrase);
				emotionItem.x = (emotionsContainer.numChildren % 8) * (emotionItem.width + 6);
				emotionItem.y = int(emotionsContainer.numChildren / 8) * (emotionItem.height + 6);
				emotionsContainer.addChild(emotionItem);
				emotionItem.addEventListener(MouseEvent.CLICK, appendEmotionText);
			}
		}
		
		private function appendEmotionText(event:MouseEvent):void
		{
			var emoItem:EmotionItem = event.target as EmotionItem;
			if(emoItem) targetWindow.appendText(emoItem.emotionText);
			MewSystem.closeEmotionWindow();
		}
		
		private function showPageButton():void
		{
			addChild(pageFlipperContainer);
			if(pageButtons && pageButtons.length){
				for each(var b:Button in pageButtons){
					b.removeEventListener(MouseEvent.CLICK, flipPage);
					pageFlipperContainer.removeChild(b);
				}
				pageButtons.length = 0;
			}
			if(curPageXMLList){
				if(!pageButtons) pageButtons = new Vector.<Button>();
				for(var i:int = 0; i < pageNum; i++){
					var btn:Button = ButtonFactory.PageButton();
					btn.toggle = true;
					pageButtons.push(btn);
					btn.x = pageFlipperContainer.numChildren * (btn.width + 10);
					pageFlipperContainer.addChild(btn);
					btn.addEventListener(MouseEvent.CLICK, flipPage);
				}
			}
			pageButtons[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			prePageFlipper = pageButtons[0];
			pageFlipperContainer.x = (this.width - pageFlipperContainer.width) / 2;
			pageFlipperContainer.y = 205 + emotionsContainer.y;
		}
		
		private function flipPage(event:MouseEvent):void
		{
			var btn:Button = event.currentTarget as Button;
			if(prePageFlipper == btn){
				btn.enabled = false;
				return;
			}
			if(prePageFlipper){
				prePageFlipper.enabled = true;
				prePageFlipper.toggle = false;
				prePageFlipper.toggle = true;
			}
			prePageFlipper = btn;
			var index:int = pageButtons.indexOf(event.target);
			if(index != -1){
				if(curPage == index) return;
				curPage = index;
				listEmotions(curPage);
			}
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h, "bottom");
			background.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		private function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		private function leftButton_mouseClickHandler(event:MouseEvent):void
		{
			if(buttonsContainer.x >= 0 || scrolling) return;
			scrolling = true;
			var targetX:int = buttonsContainer.x + masker.scrollRect.width;
			targetX = targetX >= 0 ? 0 : targetX;
			TweenLite.to(buttonsContainer, .3, {x: targetX, onComplete: scrollComplete});
		}
		
		private function rightButton_mouseClickHandler(event:MouseEvent):void
		{
			if(buttonsContainer.x <= -(buttonsContainer.width - masker.scrollRect.width) || scrolling) return;
			scrolling = true;
			var targetX:int = buttonsContainer.x - masker.scrollRect.width;
			targetX = targetX < -buttonsContainer.width + masker.scrollRect.width ? -buttonsContainer.width + masker.scrollRect.width : targetX;
			TweenLite.to(buttonsContainer, .3, {x: targetX, onComplete: scrollComplete});
		}
		
		private function scrollComplete():void
		{
			scrolling = false;
		}
		
		private function emotionTabs_mouseClickHandler(event:MouseEvent):void
		{
			var btn:Button = event.target as Button;
			if(preEmotionTab == btn){
				btn.enabled = false;
				return;
			}
			if(preEmotionTab){
				preEmotionTab.enabled = true;
				preEmotionTab.toggle = false;
				preEmotionTab.toggle = true;
			}
			prePageFlipper = null;
			preEmotionTab = btn;
			if(btn){
				var str:String = btn.label;
				if(emotionTabs.indexOf(str) != -1){
					if(str == "默认") str = "";
					if(curTabs == str) return;
					curTabs = str;
					curPage = 0;
					curPageXMLList = xmlData.emotion.(category == str);
					pageNum = Math.ceil(curPageXMLList.length() / numPerPage);
					listEmotions(0);
					showPageButton();
				}
			}
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			emotionTabs = null;
			if(emotionButtons){
				for each(var btn:Button in emotionButtons){
					btn.removeEventListener(MouseEvent.CLICK, emotionTabs_mouseClickHandler);
				}
				emotionButtons = null;
			}
			if(leftButton){
				leftButton.removeEventListener(MouseEvent.CLICK, leftButton_mouseClickHandler);
				leftButton = null;
			}
			if(rightButton){
				rightButton.removeEventListener(MouseEvent.CLICK, rightButton_mouseClickHandler);
				rightButton = null;
			}
			buttonsContainer = null;
			masker = null;
			if(urlLoader){
				try{
					urlLoader.close();
				}catch(e:Error){}
				urlLoader.removeEventListener(Event.COMPLETE, emotionsXML_loadCompleteHandler);
				urlLoader = null;
			}
			if(xmlData){
				System.disposeXML(xmlData);
				xmlData = null;
			}
			if(curPageXMLList){
				for each(var xdata:XML in curPageXMLList){
					System.disposeXML(xdata);
				}
				curPageXMLList = null;
			}
			emotionsContainer = null;
			curTabs = null;
			if(pageButtons){
				for each(var b:Button in pageButtons){
					b.removeEventListener(MouseEvent.CLICK, flipPage);
				}
			}
			pageFlipperContainer = null;
			targetWindow = null;
		}
	}
}