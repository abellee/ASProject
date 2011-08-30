package mew.modules
{
	import com.iabel.core.UISprite;
	
	import fl.controls.UIScrollBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
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
	import mew.windows.EmotionWindow;
	
	import mx.utils.StringUtil;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class NormalStatePublisher extends UISprite implements IWeiboPublisherContainer, IEmotionCorrelation
	{
		private var buttonGroup:WeiboPublisherButtonGroup = null;
		private var imageViewer:UploadImageViewer = null;
		private var bk:Sprite = null;
		private var inputTextField:TextField = null;
		private var textNumText:TextField = null;
		private var scroller:UIScrollBar = null;
		private var urlShortor:URLShortor = null;
		public function NormalStatePublisher()
		{
			super();
			
			init();
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
			
			addChild(buttonGroup);
			buttonGroup.setSize(10, 70);
			buttonGroup.init();
			buttonGroup.x = bk.x;
			buttonGroup.y = bk.height + bk.y + 20;
			buttonGroup.addEventListener(MewEvent.SCREEN_SHOT, screenShotHandler);
			buttonGroup.addEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.addEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.addEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.addEventListener(MewEvent.SHORT_URL, shortURLHandler);
		}
		
		private function inputTextField_addToStageHandler(event:Event):void
		{
			this.stage.focus = inputTextField;
		}
		
		private function screenShotHandler(event:MewEvent):void
		{
			
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
		
		public function showWeiboContent(state:String, userData:UserData, weiboData:WeiboData):void
		{
			
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
		
		public function getReplyId():String
		{
			return null;
		}
		
		public function getCommentId():String
		{
			return null;
		}
		
		public function isComment():int
		{
			return -1;
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
			bk.graphics.drawRoundRect(0, 0, 600, 270, 12, 12);
			bk.graphics.endFill();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			buttonGroup.removeEventListener(MewEvent.SCREEN_SHOT, screenShotHandler);
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
			buttonGroup = null;
			imageViewer = null;
			inputTextField = null;
			bk = null;
			textNumText = null;
			scroller = null;
		}
	}
}