package mew.modules {
	import fl.controls.CheckBox;
	import fl.controls.UIScrollBar;

	import mew.communication.SuggestDataGetter;
	import mew.data.SuggestData;
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	import mew.utils.StringUtils;
	import mew.windows.WeiBoPublisher;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import mx.utils.StringUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class ReplyOrRepostStatePublisher extends UISprite implements IWeiboPublisherContainer, IEmotionCorrelation
	{
		private var bk:Sprite = null;
		private var topBK:Sprite = null;
		private var title:TextField = null;
		private var inputTextField:TextField = null;
		private var textNumText:TextField = null;
		private var buttonGroup:WeiboPublisherButtonGroup = null;
		private var nameBox:NameBox = null;
		private var weiboText:TextField = null;
		
		private var firstCheckBox:CheckBox = null;
		private var secondCheckBox:CheckBox = null;
		
		private var ud:UserData = null;
		private var wd:WeiboData = null;
		private var rud:UserData = null;
		private var rwd:WeiboData = null;
		
		private var scroller:UIScrollBar = null;
		private var urlShortor:URLShortor = null;
		private var suggestGetter:SuggestDataGetter = null;
		private var explicitHeight:int;
		public function ReplyOrRepostStatePublisher()
		{
			super();
			
			init();
			addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
		}
		
		private function onAddedStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			explicitHeight = this.stage.nativeWindow.height;
		}
		
		private function init():void
		{
			if(!buttonGroup) buttonGroup = new WeiboPublisherButtonGroup();
			if(!title) title = new TextField();
			if(!weiboText) weiboText = new TextField();
			if(!nameBox) nameBox = new NameBox();
			if(!inputTextField) inputTextField = new TextField();
			if(!textNumText) textNumText = new TextField();
			
			drawTitleBackground();
			addChild(topBK);
			
			title.defaultTextFormat = new TextFormat(Widget.systemFont, 16, 0xFFFFFF);
			title.autoSize = TextFieldAutoSize.LEFT;
			title.selectable = false;
			title.mouseEnabled = false;
			title.mouseWheelEnabled = false;
			
			weiboText.styleSheet = Widget.linkStyle;
			weiboText.autoSize = TextFieldAutoSize.LEFT;
			weiboText.wordWrap = true;
			weiboText.mouseWheelEnabled = false;
		}
		
		public function showWeiboContent(state:String, userData:UserData, weiboData:WeiboData, repostUserData:UserData, repostData:WeiboData):void
		{
			ud = userData;
			wd = weiboData;
			rud = repostUserData;
			rwd = repostData;
			var firstCBStr:String = "";
			var secondCBStr:String = "";
			switch(state){
				case WeiBoPublisher.REPLY:
					title.text = "回	复";
					firstCBStr = "同时转发到我的微博";
					nameBox.userData = userData;
					break;
				case WeiBoPublisher.REPOST:
					title.text = "转	发";
					firstCBStr = "同时评论给 " + userData.username;
					if(rud) nameBox.userData = rud;
					else nameBox.userData = userData;
					break;
				case WeiBoPublisher.COMMENT:
					title.text = "评 论";
					firstCBStr = "同时转发到我的微博";
					nameBox.userData = userData;
					break;
			}
			nameBox.create();
			addChild(nameBox);
			nameBox.x = 20;
			nameBox.y = topBK.y + topBK.height + 20;
			if(repostUserData) secondCBStr = "同时评论给原文作者 " + repostUserData.username;
			title.width = title.textWidth;
			title.height = title.textHeight;
			addChild(title);
			title.x = (topBK.width - title.width) / 2;
			title.y = (topBK.height - title.height) / 2;
			var str:String = weiboData.content;
			if(repostData && state == WeiBoPublisher.REPOST) str = repostData.content;
			str = str.replace(/\</g, "&lt;");
			str = StringUtils.displayTopicAndAt(str);
			var urls:Array = StringUtils.getURLs(str);
			if(urls && urls.length) for each(var s:String in urls) str.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
			addChild(weiboText);
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 10;
			weiboText.htmlText = "<span class=\"mainStyle\">" + str + "</span>";
			weiboText.width = topBK.width - weiboText.x - 20;
			weiboText.height = weiboText.textHeight;
			
			drawTextBackground();
			addChild(bk);
			bk.x = 20;
			bk.y = weiboText.y + weiboText.height + 10;
			
			inputTextField = new TextField();
			inputTextField.defaultTextFormat = new TextFormat(Widget.systemFont, 14, 0x4c4c4c, null, null, null, null, null, null, null, null, null, 5);
			inputTextField.type = TextFieldType.INPUT;
			inputTextField.wordWrap = true;
			inputTextField.multiline = true;
			addChild(inputTextField);
			inputTextField.x = bk.x + 10;
			inputTextField.y = bk.y + 10;
			inputTextField.width = bk.width - inputTextField.x + 10;
			inputTextField.height = bk.height - 20;
			inputTextField.addEventListener(Event.CHANGE, inputTextField_onChangeHandler);
			inputTextField.addEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
			inputTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			if(repostData && state == WeiBoPublisher.REPOST) inputTextField.text = "//@" + ud.username + ": " + weiboData.content;
			else if(weiboData.username && state == WeiBoPublisher.REPLY){
				inputTextField.text = "回复@" + weiboData.username + ": ";
				inputTextField.setSelection(10000, 10000);
			}
			if(state == WeiBoPublisher.REPOST) inputTextField.setSelection(0, 0);
			
			textNumText = new TextField();
			textNumText.defaultTextFormat = new TextFormat(Widget.systemFont, 40, 0x000000);
			textNumText.autoSize = TextFieldAutoSize.LEFT;
			textNumText.text = "140";
			textNumText.width = textNumText.textWidth;
			textNumText.height = textNumText.textHeight;
			textNumText.selectable = false;
			textNumText.mouseEnabled = false;
			textNumText.mouseWheelEnabled = false;
			textNumText.alpha = .2;
			addChild(textNumText);
			textNumText.x = bk.x + bk.width - textNumText.width - 15;
			textNumText.y = bk.y + bk.height - textNumText.height - 10;
			
			var cbSize:int = 0;
			if(firstCBStr != ""){
				firstCheckBox = ButtonFactory.SystemCheckBox();
				firstCheckBox.label = firstCBStr;
				firstCheckBox.x = bk.x + 5;
				firstCheckBox.y = bk.height + bk.y + 5;
				addChild(firstCheckBox);
				cbSize = firstCheckBox.x + firstCheckBox.width;
			}
			
			if(secondCBStr != ""){
				secondCheckBox = ButtonFactory.SystemCheckBox();
				secondCheckBox.label = secondCBStr;
				addChild(secondCheckBox);
				if(firstCheckBox){
					secondCheckBox.x = firstCheckBox.x;
					secondCheckBox.y = firstCheckBox.y + firstCheckBox.height + 5;
				}
				if(secondCheckBox.x + secondCheckBox.width > cbSize) cbSize = secondCheckBox.x + secondCheckBox.width;
			}
			
			addChild(buttonGroup);
			buttonGroup.setSize(10, 40);
			buttonGroup.init(false);
			buttonGroup.x = bk.x + bk.width - buttonGroup.width - 150;
			buttonGroup.y = bk.height + bk.y + 50;
			buttonGroup.addEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.addEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.addEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.addEventListener(MewEvent.SHORT_URL, shortURLHandler);
			
			topBK.addEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
		}
		
		public function getFirstSelect():Boolean
		{
			return firstCheckBox.selected;
		}
		
		public function getSecondSelect():Boolean
		{
			return secondCheckBox.selected;
		}
		
		public function hasFirstCheckBox():Boolean
		{
			if(firstCheckBox) return true;
			else return false;
		}
		
		public function hasSecondCheckBox():Boolean
		{
			if(secondCheckBox) return true;
			else return false;
		}
		
		public function getUserData():UserData
		{
			return ud;
		}
		
		public function getRepostUserData():UserData
		{
			return rud;
		}
		
		public function getWeiboData():WeiboData
		{
			return wd;
		}
		
		public function getRepostData():WeiboData
		{
			return rwd;
		}
		
		private function dragNativeWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		private function inputTextField_addToStageHandler(event:Event):void
		{
			this.stage.focus = inputTextField;
			inputTextField.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function emotionHandler(event:MewEvent):void
		{
			var emotionBtnPos:Point = buttonGroup.getEmotionButtonPos();
			emotionBtnPos.x = emotionBtnPos.x + buttonGroup.x;
			emotionBtnPos.y = emotionBtnPos.y + buttonGroup.y;
			var realPoint:Point = MewSystem.app.weiboPublishWindow.globalToScreen(emotionBtnPos);
			MewSystem.openEmotionWindow(realPoint, this);
		}
		
		private function topicHandler(event:MewEvent):void
		{
			this.stage.focus = inputTextField;
			var selectedText:String = inputTextField.selectedText;
			if(selectedText && selectedText == "请在这里输入自定义话题") return;
			if(selectedText){
				inputTextField.replaceSelectedText("#" + selectedText + "#");
				inputTextField.dispatchEvent(new Event(Event.CHANGE));
				return;
			}
			var pos:int = inputTextField.caretIndex;
			inputTextField.replaceText(pos, pos, "#请在这里输入自定义话题#");
			inputTextField.setSelection(pos + 1, pos + 12);
			inputTextField.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function clearContentHandler(event:MewEvent):void
		{
			if(inputTextField.text == "") return;
			resetContent(false);
		}
		
		private function shortURLHandler(event:MewEvent):void
		{
			if(urlShortor){
				removeChild(urlShortor);
				urlShortor.removeEventListener(MewEvent.SHORTEN_URL_SUCCESS, shortenURL_successHandler);
				urlShortor = null;
				return;
			}
			urlShortor = new URLShortor();
			urlShortor.parentStage = MewSystem.app.weiboPublishWindow.container;
			addChild(urlShortor);
			urlShortor.addEventListener(MewEvent.SHORTEN_URL_SUCCESS, shortenURL_successHandler);
			var selectedText:String = inputTextField.selectedText;
			if(selectedText) urlShortor.appendText(selectedText);
			var btnPos:Point = buttonGroup.getShortButtonPos();
			urlShortor.x = buttonGroup.x + btnPos.x - urlShortor.width / 2;
			urlShortor.y = buttonGroup.y - urlShortor.height;
		}
		
		private function shortenURL_successHandler(event:MewEvent):void
		{
			if(urlShortor){
				if(!urlShortor.originStr){
					inputTextField.replaceText(inputTextField.selectionBeginIndex, inputTextField.selectionEndIndex, urlShortor.getShortenURL());
					return;
				}else{
					var index:int = inputTextField.text.search(urlShortor.originStr);
					if(index == -1){
						inputTextField.replaceText(inputTextField.selectionBeginIndex, inputTextField.selectionEndIndex, urlShortor.getShortenURL());
					}else{
						inputTextField.replaceText(index, index + urlShortor.originStr.length, urlShortor.getShortenURL());
					}
				}
			}
		}
		
		private function inputTextField_onChangeHandler(event:Event):void
		{
			var str:String = inputTextField.text;
			var start:int = inputTextField.selectionBeginIndex;
			var lastAt:int = str.lastIndexOf("@", start);
			if(lastAt != -1){
				var validStr:String = str.substring(lastAt, start);
				var blank:int = validStr.search(/\s/g);
				if(blank == -1 && validStr != "@"){
					var q:String = validStr.substr(1);
					if(!suggestGetter) suggestGetter = new SuggestDataGetter();
					if(!suggestGetter.hasEventListener(MewEvent.SUGGESTION_SUCCESS)){
						suggestGetter.addEventListener(MewEvent.SUGGESTION_SUCCESS, suggestGetSuccess);
						suggestGetter.addEventListener(MewEvent.SUGGESTION_FAILED, suggestGetFailed);
						suggestGetter.addEventListener(MewEvent.NO_SUGGESTION, noSuggestion);
					}
					suggestGetter.getData(q);
				}else{
					if(suggestGetter) suggestGetter.dispatchEvent(new MewEvent(MewEvent.NO_SUGGESTION));
				}
			}
			var len:Number = StringUtils.getStringLength(str);
			textNumText.text = 140 - len + "";
			textNumText.x = bk.x + bk.width - textNumText.width - 15;
			textNumText.y = bk.y + bk.height - textNumText.height - 10;
			if(inputTextField.maxScrollV > 1){
				if(!scroller){
					inputTextField.width = bk.width - inputTextField.x - 10;
					scroller = new UIScrollBar();
					addChild(scroller);
					scroller.setSize(inputTextField.width, inputTextField.height);
					scroller.x = inputTextField.x + inputTextField.width + 5;
					scroller.y = inputTextField.y;
					scroller.scrollTarget = inputTextField;
				}
				textNumText.x = bk.x + bk.width - textNumText.width - 30;
				textNumText.y = bk.y + bk.height - textNumText.height - 10;
				scroller.scrollPosition = scroller.maxScrollPosition;
			}else{
				removeScrollBar();
			}
		}
		
		public function getContent():String
		{
			var str:String = inputTextField.text;
			str = StringUtil.trim(str);
			str = str.replace(/\n\r\t/g, " ");
			if(Number(textNumText.text) < 0) return null;
			return str;
		}
		
		private function noSuggestion(event : MewEvent) : void
		{
			trace("no suggestion!");
			if(MewSystem.app.suggestor){
				if(this.contains(MewSystem.app.suggestor)) this.removeChild(MewSystem.app.suggestor);
				MewSystem.app.suggestor = null;
			}
			suggestGetter.removeEventListener(MewEvent.SUGGESTION_SUCCESS, suggestGetSuccess);
			suggestGetter.removeEventListener(MewEvent.SUGGESTION_FAILED, suggestGetFailed);
			suggestGetter.removeEventListener(MewEvent.NO_SUGGESTION, noSuggestion);
		}

		private function suggestGetFailed(event : MewEvent) : void
		{
			if(MewSystem.app.suggestor){
				if(this.contains(MewSystem.app.suggestor)) this.removeChild(MewSystem.app.suggestor);
				MewSystem.app.suggestor = null;
			}
			suggestGetter.removeEventListener(MewEvent.SUGGESTION_SUCCESS, suggestGetSuccess);
			suggestGetter.removeEventListener(MewEvent.SUGGESTION_FAILED, suggestGetFailed);
			suggestGetter.removeEventListener(MewEvent.NO_SUGGESTION, noSuggestion);
		}

		private function suggestGetSuccess(event : MewEvent) : void
		{
			trace("success!");
			var data:Vector.<SuggestData> = suggestGetter.data;
			var index:int = inputTextField.caretIndex;
			if(index != -1){
				var rect:Rectangle = inputTextField.getCharBoundaries(index-1);
				var pos:Point = new Point(inputTextField.x + rect.x, inputTextField.y + rect.y);
				MewSystem.openSuggestWindow(pos, data);
				addChild(MewSystem.app.suggestor);
				this.stage.nativeWindow.height = MewSystem.app.suggestor.y + MewSystem.app.suggestor.height > explicitHeight ?
				 MewSystem.app.suggestor.y + MewSystem.app.suggestor.height : explicitHeight;
			}
		}

		private function keyDownHandler(event : KeyboardEvent) : void
		{
			switch(event.keyCode){
				case Keyboard.UP:
					if(MewSystem.app.suggestor){
						event.preventDefault();
						MewSystem.app.suggestor.previous();
					}
					break;
				case Keyboard.DOWN:
					if(MewSystem.app.suggestor){
						event.preventDefault();
						MewSystem.app.suggestor.next();
					}
					break;
				case Keyboard.ENTER:
					if(MewSystem.app.suggestor){
						event.preventDefault();
						var str:String = inputTextField.text;
						var start:int = inputTextField.selectionBeginIndex;
						var lastAt:int = str.lastIndexOf("@", start);
						if(lastAt != -1){
							var validStr:String = str.substring(lastAt, start);
							var blank:int = validStr.search(/\s/g);
							if(blank == -1 && validStr != "@"){
								var selectedName:String = MewSystem.app.suggestor.selectedName + " ";
								inputTextField.replaceText(lastAt + 1, start, selectedName);
								var realIndex:int = lastAt + selectedName.length + 1;
								inputTextField.setSelection(realIndex, realIndex);
								suggestGetter.dispatchEvent(new MewEvent(MewEvent.NO_SUGGESTION));
							}
						}
					}
					break;
				case Keyboard.ESCAPE:
					if(suggestGetter) suggestGetter.dispatchEvent(new MewEvent(MewEvent.NO_SUGGESTION));
					break;
			}
		}
		
		private function removeScrollBar():void
		{
			if(scroller){
				removeChild(scroller);
				scroller = null;
			}
			if(inputTextField.width < (bk.width - inputTextField.x + 10)){
				inputTextField.width = bk.width - inputTextField.x + 10;
			}
		}
		
		public function appendText(str:String):void
		{
			inputTextField.replaceText(inputTextField.selectionBeginIndex, inputTextField.selectionEndIndex, str);
			inputTextField.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function getImageData():ByteArray
		{
			return null;
		}
		
		public function resetContent(removeImage:Boolean = true):void
		{
			inputTextField.text = "";
			textNumText.text = "140";
			textNumText.x = bk.x + bk.width - textNumText.width - 15;
			textNumText.y = bk.y + bk.height - textNumText.height - 10;
			this.stage.focus = inputTextField;
			removeScrollBar();
		}
		
		private function drawTitleBackground():void
		{
			if(!topBK) topBK = new Sprite();
			topBK.graphics.clear();
			topBK.graphics.beginFill(Widget.mainColor, 1.0);
			topBK.graphics.drawRoundRectComplex(0, 0, 640, 30, 8, 8, 0, 0);
			topBK.graphics.endFill();
			topBK.mouseChildren = false;
		}
		
		private function drawTextBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .3);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, topBK.width - 40, 240 - weiboText.y - weiboText.height, 12, 12);
			bk.graphics.endFill();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			buttonGroup.removeEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.removeEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.removeEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.removeEventListener(MewEvent.SHORT_URL, shortURLHandler);
			
			if(inputTextField){
				inputTextField.removeEventListener(Event.CHANGE, inputTextField_onChangeHandler);
				inputTextField.removeEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
				inputTextField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				inputTextField = null;
			}
			
			if(urlShortor){
				urlShortor.removeEventListener(MewEvent.SHORTEN_URL_SUCCESS, shortenURL_successHandler);
				urlShortor = null;
			}
			if(topBK){
				topBK.removeEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
				topBK = null;
			}
			if(suggestGetter){
				suggestGetter.dealloc();
				suggestGetter.removeEventListener(MewEvent.SUGGESTION_SUCCESS, suggestGetSuccess);
				suggestGetter.removeEventListener(MewEvent.SUGGESTION_FAILED, suggestGetFailed);
				suggestGetter.removeEventListener(MewEvent.NO_SUGGESTION, noSuggestion);
				suggestGetter = null;
			}
			if(MewSystem.app.suggestor){
				if(this.contains(MewSystem.app.suggestor)) this.removeChild(MewSystem.app.suggestor);
				MewSystem.app.suggestor = null;
			}
			bk = null;
			title = null;
			textNumText = null;
			buttonGroup = null;
			nameBox = null;
			weiboText = null;
			ud = null;
			wd = null;
			scroller = null;
		}
	}
}