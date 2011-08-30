package mew.modules
{
	import com.iabel.core.UISprite;
	
	import fl.controls.UIScrollBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.events.MewEvent;
	import mew.utils.StringUtils;
	import mew.windows.WeiBoPublisher;
	
	import mx.utils.StringUtil;
	
	import system.MewSystem;
	
	import widget.Widget;
	
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
		private var ud:UserData = null;
		private var wd:WeiboData = null;
		private var scroller:UIScrollBar = null;
		private var urlShortor:URLShortor = null;
		public function ReplyOrRepostStatePublisher()
		{
			super();
			
			init();
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
		
		public function showWeiboContent(state:String, userData:UserData, weiboData:WeiboData):void
		{
			ud = userData;
			wd = weiboData;
			nameBox.userData = userData;
			nameBox.create();
			addChild(nameBox);
			nameBox.x = 20;
			nameBox.y = topBK.y + topBK.height + 20;
			if(state == WeiBoPublisher.REPLY){
				title.text = "回	复";
			}else{
				title.text = "转	发";
			}
			title.width = title.textWidth;
			title.height = title.textHeight;
			addChild(title);
			title.x = (topBK.width - title.width) / 2;
			title.y = (topBK.height - title.height) / 2;
			var str:String = weiboData.content.replace(/\</g, "&lt;");
			str = StringUtils.displayTopicAndAt(str);
			var urls:Array = StringUtils.getURLs(str);
			if(urls && urls.length){
				for each(var s:String in urls){
					str.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
				}
			}
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
			
			addChild(buttonGroup);
			buttonGroup.setSize(10, 70);
			buttonGroup.init(false);
			buttonGroup.x = bk.x + bk.width - buttonGroup.width - 120;
			buttonGroup.y = bk.height + bk.y + 20;
			buttonGroup.addEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.addEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.addEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.addEventListener(MewEvent.SHORT_URL, shortURLHandler);
			
			topBK.addEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
		}
		
		private function dragNativeWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		private function inputTextField_addToStageHandler(event:Event):void
		{
			this.stage.focus = inputTextField;
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
				return;
			}
			var len:int = inputTextField.length;
			inputTextField.appendText("#请在这里输入自定义话题#");
			inputTextField.setSelection(len + 1, len + 12);
		}
		
		private function clearContentHandler(event:MewEvent):void
		{
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
			urlShortor.parentStage = MewSystem.app.weiboPublishWindow.stage;
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
			var len:Number = StringUtils.getStringLength(inputTextField.text);
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
		
		public function getReplyId():String
		{
			return wd.id;
		}
		
		public function getCommentId():String
		{
			return wd.cid;
		}
		
		public function isComment():int
		{
			return -1;
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
			topBK.graphics.drawRoundRectComplex(0, 0, 640, 30, 12, 12, 0, 0);
			topBK.graphics.endFill();
			topBK.mouseChildren = false;
			topBK.mouseEnabled = false;
		}
		
		private function drawTextBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .3);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, topBK.width - 40, 280 - weiboText.y - weiboText.height, 12, 12);
			bk.graphics.endFill();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			buttonGroup.removeEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.removeEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.removeEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.removeEventListener(MewEvent.SHORT_URL, shortURLHandler);
			
			inputTextField.removeEventListener(Event.CHANGE, inputTextField_onChangeHandler);
			inputTextField.removeEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
			
			if(urlShortor){
				urlShortor.removeEventListener(MewEvent.SHORTEN_URL_SUCCESS, shortenURL_successHandler);
				urlShortor = null;
			}
			if(topBK){
				topBK.addEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
				topBK = null;
			}
			bk = null;
			title = null;
			inputTextField = null;
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