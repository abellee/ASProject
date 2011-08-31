package mew.windows {
	import mew.communication.SuggestDataGetter;
	import mew.modules.ITiming;
	import fl.controls.Button;
	import fl.controls.UIScrollBar;

	import mew.data.TimingWeiboVariable;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	import mew.modules.IEmotionCorrelation;
	import mew.modules.TimeSettor;
	import mew.modules.URLShortor;
	import mew.modules.UploadImageViewer;
	import mew.modules.WeiboPublisherButtonGroup;
	import mew.utils.StringUtils;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;
	import com.iabel.util.ScaleBitmap;

	import mx.utils.StringUtil;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class TimingWeiboWindow extends ALNativeWindow implements IEmotionCorrelation, ITiming
	{
		private var topBK:Sprite = null;
		private var titleText:TextField = null;
		private var leftArrow:Button = null;
		private var rightArrow:Button = null;
		private var masker:Sprite = null;
		private var buttonContainer:Sprite = null;
		private var timeButtons:Vector.<String> = null;
		private var hline:Sprite = null;
		
		private var buttonGroup:WeiboPublisherButtonGroup = null;
		private var imageViewer:UploadImageViewer = null;
		private var bk:Sprite = null;
		private var inputTextField:TextField = null;
		private var textNumText:TextField = null;
		private var scroller:UIScrollBar = null;
		private var urlShortor:URLShortor = null;
		private var sendButton:Button = null;
		
		private var timeline:ScaleBitmap = null;
		
		private var timeSettor:TimeSettor = null;
		private var suggestGetter:SuggestDataGetter = null;
		
		private var scrolling:Boolean = false;
		
		public function TimingWeiboWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(700, 450);
			background.alpha = 0;
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			drawTitleBackground();
			addChild(topBK);
			topBK.addEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
			
			TweenLite.to(background, .3, {alpha: 1});
			
			if(!titleText) titleText = new TextField();
			titleText.defaultTextFormat = new TextFormat(Widget.systemFont, 16, 0xFFFFFF);
			titleText.autoSize = TextFieldAutoSize.LEFT;
			titleText.selectable = false;
			titleText.mouseEnabled = false;
			titleText.mouseWheelEnabled = false;
			titleText.text = "定时微博发布器";
			titleText.width = titleText.textWidth;
			titleText.height = titleText.textHeight;
			addChild(titleText);
			titleText.x = (topBK.width - titleText.width) / 2 + 10;
			titleText.y = (topBK.height - titleText.height) / 2 + 10;
			
			if(!buttonContainer) buttonContainer = new Sprite();
			if(!masker) masker = new Sprite();
			masker.mouseEnabled = false;
			masker.scrollRect = new Rectangle(0, 0, topBK.width - 80, 40);
			leftArrow = ButtonFactory.TimingArrow();
			leftArrow.label = "<";
			addChild(leftArrow);
			leftArrow.x = 20;
			leftArrow.y = topBK.height + 20;
			
			rightArrow = ButtonFactory.TimingArrow();
			rightArrow.label = ">";
			addChild(rightArrow);
			rightArrow.x = background.width - rightArrow.width;
			rightArrow.y = leftArrow.y;
			timeButtons = new Vector.<String>();
			for(var i:int = 0; i<24; i++){
				var btn:Button = ButtonFactory.TimingClockButton();
				var str:String = "AM";
				if(i >= 12) str = "PM";
				btn.label = i + str;
				timeButtons.push(btn);
				btn.x = buttonContainer.numChildren * (btn.width + 10);
				buttonContainer.addChild(btn);
			}
			masker.addChild(buttonContainer);
			addChild(masker);
			masker.x = leftArrow.x + leftArrow.width + 10;
			masker.y = leftArrow.y;
			
			drawLine();
			addChild(hline);
			
			leftArrow.addEventListener(MouseEvent.CLICK, leftButton_mouseClickHandler);
			rightArrow.addEventListener(MouseEvent.CLICK, rightButton_mouseClickHandler);
			
			if(!buttonGroup) buttonGroup = new WeiboPublisherButtonGroup();
			if(!imageViewer) imageViewer = new UploadImageViewer(100);
			if(!inputTextField) inputTextField = new TextField();
			if(!textNumText) textNumText = new TextField();
			
			addChild(imageViewer);
			imageViewer.x = 20;
			imageViewer.y = background.height - imageViewer.height - 10 + background.y;
			
			drawTextBackground();
			addChild(bk);
			bk.x = imageViewer.x + imageViewer.width + 10;
			bk.y = imageViewer.y;
			
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
			inputTextField.border = true;
			addChild(inputTextField);
			inputTextField.x = bk.x + 10;
			inputTextField.y = bk.y + 10;
			inputTextField.width = bk.width + bk.x - inputTextField.x - 10;
			inputTextField.height = bk.height - 20;
			inputTextField.addEventListener(Event.CHANGE, inputTextField_onChangeHandler);
			inputTextField.addEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
			
			addChild(buttonGroup);
			buttonGroup.gap = 20;
			buttonGroup.setSize(10, 70);
			buttonGroup.init();
			buttonGroup.x = bk.x;
			buttonGroup.y = bk.height + bk.y + 20;
			buttonGroup.addEventListener(MewEvent.SCREEN_SHOT, screenShotHandler);
			buttonGroup.addEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.addEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.addEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.addEventListener(MewEvent.SHORT_URL, shortURLHandler);
			
			timeSettor = new TimeSettor();
			addChild(timeSettor);
			timeSettor.x = bk.x + bk.width + 10;
			timeSettor.y = bk.y;
			
			sendButton = ButtonFactory.SendButton();
			addChild(sendButton);
			sendButton.x = (timeSettor.width - sendButton.width) / 2 + timeSettor.x;
			sendButton.y = (background.height + 110 + timeSettor.y) / 2 - sendButton.height / 2;
			sendButton.addEventListener(MouseEvent.CLICK, sendButton_mouseClickHandler);
		}

		private function sendButton_mouseClickHandler(event : MouseEvent) : void
		{
			if(Number(textNumText.text) <= 0){
				MewSystem.showLightAlert("定时微博的内容不能为空!", this.stage);
				return;
			}else if(Number(textNumText.text) > 140){
				MewSystem.showLightAlert("定时微博的字数不得大于140字!", this.stage);
				return;
			}
			var str:String = inputTextField.text;
			str = str.replace(/\s/g, " ");
			if(str == ""){
				MewSystem.showLightAlert("定时微博的内容不能为空!", this.stage);
				return;
			}
			str = inputTextField.text;
			str = StringUtil.trim(str);
			str = str.replace(/\n\r\t/g, " ");
			
			if(timeSettor){
				var year:int = timeSettor.year;
				var month:int = timeSettor.month;
				var date:int = timeSettor.date;
				var hour:int = timeSettor.hour;
				var minute:int = timeSettor.minute;
				var targetTime:Number = new Date(year, month - 1, date, hour, minute).time;
				
				var now:Date = new Date();
				var time:Number = now.time;
				trace(year, month, date, hour, minute, targetTime, time);
				if(targetTime - time > 60000){
					var data:TimingWeiboVariable = new TimingWeiboVariable();
					data.content = str;
					data.createTime = time;
					if(imageViewer.imageExtension){
						data.img = time + "." + imageViewer.imageExtension;
						copyImage(data.img);
					}
					data.state = 0;
					data.time = targetTime;
					MewSystem.app.timingWeiboManager.target = this;
					MewSystem.app.timingWeiboManager.writeData(data);
					resetContent(true);
				}else{
					MewSystem.showLightAlert("定时微博的时间必需大于当前时间!", this.stage);
				}
			}
		}

		private function copyImage(newName:String) : void
		{
			if(imageViewer.imageFile){
				var file:File = File.applicationStorageDirectory.resolvePath("timing/" + newName);
				trace(imageViewer.imageFile.nativePath, file.exists, file.nativePath);
				imageViewer.imageFile.copyTo(file);
			}
		}
		
		private function drawLine():void
		{
			if(!hline) hline = new Sprite();
			hline.graphics.clear();
			hline.graphics.lineStyle(2, 0x000000, 1.0);
			hline.graphics.moveTo(leftArrow.x, leftArrow.y + leftArrow.height + 10);
			hline.graphics.lineTo(rightArrow.x + rightArrow.width, rightArrow.y + rightArrow.height + 10);
		}
		
		private function leftButton_mouseClickHandler(event:MouseEvent):void
		{
			if(buttonContainer.x >= 0 || scrolling) return;
			scrolling = true;
			var targetX:int = buttonContainer.x + masker.scrollRect.width >= 0 ? 0 : buttonContainer.x + masker.scrollRect.width;
			TweenLite.to(buttonContainer, .3, {x: targetX, onComplete: scrollComplete});
		}
		
		private function rightButton_mouseClickHandler(event:MouseEvent):void
		{
			if(buttonContainer.x <= -(buttonContainer.width - masker.scrollRect.width) || scrolling) return;
			scrolling = true;
			var targetX:int = buttonContainer.x - masker.scrollRect.width <= -(buttonContainer.width - masker.scrollRect.width) ?
			 -(buttonContainer.width - masker.scrollRect.width) : buttonContainer.x - masker.scrollRect.width;
			TweenLite.to(buttonContainer, .3, {x: targetX, onComplete: scrollComplete});
		}
		
		private function scrollComplete():void
		{
			scrolling = false;
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
			var realPoint:Point = this.stage.nativeWindow.globalToScreen(emotionBtnPos);
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
			urlShortor.parentStage = this.stage;
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
					trace(q);
					if(!suggestGetter) suggestGetter = new SuggestDataGetter();
					suggestGetter.getData(q);
				}
			}
			var len:Number = StringUtils.getStringLength(str);
			textNumText.text = 140 - len + "";
			textNumText.x = bk.x + bk.width - textNumText.width - 15;
			textNumText.y = bk.y + bk.height - textNumText.height - 10;
			if(inputTextField.maxScrollV > 1){
				if(!scroller){
					inputTextField.width = bk.width + bk.x - inputTextField.x - 30;
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
			if(inputTextField.width < (bk.width + bk.x - inputTextField.x - 10)){
				inputTextField.width = bk.width + bk.x - inputTextField.x - 10;
			}
		}
		
		public function appendText(str:String):void
		{
			inputTextField.replaceText(inputTextField.selectionBeginIndex, inputTextField.selectionEndIndex, str);
			inputTextField.dispatchEvent(new Event(Event.CHANGE));
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
		
		public function timingWeiboData(data:Vector.<TimingWeiboVariable>):void
		{
			
		}
		public function showLightAlert(str:String):void
		{
			MewSystem.showLightAlert(str, this.stage);
		}
		
		private function drawTextBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .3);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, 300, 80, 12, 12);
			bk.graphics.endFill();
		}
		
		override protected function drawBackground(w:int, h:int):void
		{
			super.drawBackground(w, h);
			background.addEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
		}
		
		private function dragNativeWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
		}
		
		private function drawTitleBackground():void
		{
			if(!topBK) topBK = new Sprite();
			topBK.graphics.clear();
			topBK.graphics.beginFill(Widget.mainColor, 1.0);
			topBK.graphics.drawRoundRectComplex(10, 10, background.width, 30, 12, 12, 0, 0);
			topBK.graphics.endFill();
			topBK.mouseChildren = false;
		}
	}
}