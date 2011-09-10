package mew.modules {
	import flash.events.FocusEvent;
	import fl.controls.UIScrollBar;

	import mew.communication.SuggestDataGetter;
	import mew.data.SuggestData;
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.events.MewEvent;
	import mew.utils.StringUtils;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import mx.utils.StringUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class NormalStatePublisher extends UISprite implements IWeiboPublisherContainer, IEmotionCorrelation, IScreenShot
	{
		private var buttonGroup:WeiboPublisherButtonGroup = null;
		private var imageViewer:UploadImageViewer = null;
		private var bk:Sprite = null;
		private var inputTextField:TextField = null;
		private var textNumText:TextField = null;
		private var scroller:UIScrollBar = null;
		private var urlShortor:URLShortor = null;
		private var suggestGetter:SuggestDataGetter = null;
		private var explicitHeight:int;
		private var screenShotor:ScreenShotor = null;
		public function NormalStatePublisher()
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
			drawTextBackground();
			addChild(bk);
			bk.x = 20;
			bk.y = 20;
			
			if(!buttonGroup) buttonGroup = new WeiboPublisherButtonGroup();
			if(!imageViewer) imageViewer = new UploadImageViewer();
			if(!inputTextField) inputTextField = new TextField();
			if(!textNumText) textNumText = new TextField();
			
			addChild(imageViewer);
			imageViewer.x = bk.x + 10;
			imageViewer.y = bk.y + 10;
			
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
			
			inputTextField = new TextField();
			inputTextField.defaultTextFormat = new TextFormat(Widget.systemFont, 14, 0x4c4c4c, null, null, null, null, null, null, null, null, null, 5);
			inputTextField.type = TextFieldType.INPUT;
			inputTextField.wordWrap = true;
			inputTextField.multiline = true;
			addChild(inputTextField);
			inputTextField.x = imageViewer.x + imageViewer.width + 30;
			inputTextField.y = bk.y + 10;
			inputTextField.width = bk.width - inputTextField.x + 10;
			inputTextField.height = bk.height - 20;
			inputTextField.addEventListener(Event.CHANGE, inputTextField_onChangeHandler);
			inputTextField.addEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
			inputTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			inputTextField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			
			addChild(buttonGroup);
			buttonGroup.setSize(10, 70);
			buttonGroup.init();
			buttonGroup.x = bk.x + 20;
			buttonGroup.y = bk.height + bk.y;
			buttonGroup.addEventListener(MewEvent.SCREEN_SHOT, screenShotHandler);
			buttonGroup.addEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.addEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.addEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.addEventListener(MewEvent.SHORT_URL, shortURLHandler);
		}
		
		private function onFocusIn(event:FocusEvent):void
		{
			MewSystem.reactivateFunc = reactivate;
		}
		
		public function reactivate():void
		{
			MewSystem.reactivateFunc = null;
			this.stage.nativeWindow.activate();
			this.stage.focus = inputTextField;
		}
		
		private function inputTextField_addToStageHandler(event:Event):void
		{
			this.stage.focus = inputTextField;
		}
		
		private function screenShotHandler(event:MewEvent):void
		{
			if(!screenShotor){
				screenShotor = new ScreenShotor();
				screenShotor.parent = this;
			}
			screenShotor.screenshot();
		}
		
		private function emotionHandler(event:MewEvent):void
		{
			var emotionBtnPos:Point = buttonGroup.getEmotionButtonPos();
			emotionBtnPos.x = emotionBtnPos.x + buttonGroup.x + 6;
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
		
		public function showWeiboContent(state:String, userData:UserData, weiboData:WeiboData, repostUserData:UserData, repostData:WeiboData, additionStr:String):void
		{
			if(userData) appendText("@" + userData.username + ": ");
		}
		
		public function getFirstSelect():Boolean
		{
			return false;
		}
		
		public function getSecondSelect():Boolean
		{
			return false;
		}
		
		public function hasFirstCheckBox():Boolean
		{
			return false;
		}
		
		public function hasSecondCheckBox():Boolean
		{
			return false;
		}
		
		public function getRepostID():String
		{
			return null;
		}
		
		public function getUserData():UserData
		{
			return null;
		}
		
		public function getRepostUserData():UserData
		{
			return null;
		}
		
		public function getWeiboData():WeiboData
		{
			return null;
		}
		
		public function getRepostData():WeiboData
		{
			return null;
		}
		
		public function getContent():String
		{
			var str:String = inputTextField.text;
			str = StringUtil.trim(str);
			str = str.replace(/\n\r\t/g, " ");
			if(Number(textNumText.text) < 0) return null;
			return str;
		}
		
		public function getImageData():ByteArray
		{
			return imageViewer.byteArray;
		}
		
		public function resetContent(removeImage:Boolean = true):void
		{
			inputTextField.text = "";
			textNumText.text = "140";
			if(removeImage && imageViewer.byteArray) imageViewer.reset();
			textNumText.x = bk.x + bk.width - textNumText.width - 15;
			textNumText.y = bk.y + bk.height - textNumText.height - 10;
			this.stage.focus = inputTextField;
			removeScrollBar();
		}
		
		private function drawTextBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .3);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, 600, 250, 12, 12);
			bk.graphics.endFill();
		}
		
		public function screenComplete(byteArray:ByteArray):void
		{
			imageViewer.byteArray = byteArray;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			buttonGroup.removeEventListener(MewEvent.SCREEN_SHOT, screenShotHandler);
			buttonGroup.removeEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.removeEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.removeEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.removeEventListener(MewEvent.SHORT_URL, shortURLHandler);
			
			if(inputTextField){
				inputTextField.removeEventListener(Event.CHANGE, inputTextField_onChangeHandler);
				inputTextField.removeEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
				inputTextField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				inputTextField.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				inputTextField = null;
			}
			if(urlShortor){
				urlShortor.removeEventListener(MewEvent.SHORTEN_URL_SUCCESS, shortenURL_successHandler);
				urlShortor = null;
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
			buttonGroup = null;
			imageViewer = null;
			bk = null;
			textNumText = null;
			scroller = null;
			MewSystem.reactivateFunc = null;
		}
	}
}