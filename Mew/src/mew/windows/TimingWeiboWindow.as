package mew.windows {
	import fl.data.DataProvider;
	import fl.controls.ComboBox;
	import flash.events.FocusEvent;
	import mew.data.SystemSettingData;
	import fl.controls.Button;
	import fl.controls.UIScrollBar;

	import mew.communication.SuggestDataGetter;
	import mew.data.SuggestData;
	import mew.data.TimingWeiboVariable;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	import mew.modules.IEmotionCorrelation;
	import mew.modules.ITiming;
	import mew.modules.TimeSettor;
	import mew.modules.TimingPoint;
	import mew.modules.URLShortor;
	import mew.modules.UploadImageViewer;
	import mew.modules.WeiboPublisherButtonGroup;
	import mew.utils.StringUtils;

	import resource.Resource;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.iabel.util.ScaleBitmap;

	import mx.utils.StringUtil;

	import flash.display.Bitmap;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class TimingWeiboWindow extends ALNativeWindow implements IEmotionCorrelation, ITiming
	{
		private var topBK:Sprite = null;
		private var titleText:TextField = null;
		private var leftArrow:Button = null;
		private var rightArrow:Button = null;
		private var masker:Sprite = null;
		private var buttonContainer:Sprite = null;
		private var timeButtons:Vector.<Button> = null;
		private var hline:Sprite = null;
		
		private var buttonGroup:WeiboPublisherButtonGroup = null;
		private var imageViewer:UploadImageViewer = null;
		private var bk:Sprite = null;
		private var inputTextField:TextField = null;
		private var textNumText:TextField = null;
		private var scroller:UIScrollBar = null;
		private var urlShortor:URLShortor = null;
		private var sendButton:Button = null;
		private var pointContainer:Sprite = null;
		
		private var timeline:ScaleBitmap = null;
		
		private var timeSettor:TimeSettor = null;
		private var suggestGetter:SuggestDataGetter = null;
		
		private var scrolling:Boolean = false;
		private var explicitHeight:int;
		
		private var closeButton:Button = null;
		private var pointList:Vector.<TimingPoint> = null;
		private var minTime:Number = 0;
		private var maxTime:Number = 0;
		private var perSize:Number = 0;
		
		private var curYear:Number = 0;
		private var curMonth:Number = 0;
		private var curDay:Number = 0;
		private var curMillisecond:Number = 0;
		
		private var curDateSelector:ComboBox = null;
		
		private var detailWindow:TimingDetailWindow = null;
		private var preTab:Button = null;
		public function TimingWeiboWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(700, 500);
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			explicitHeight = this.stage.nativeWindow.height;
			
			drawTitleBackground();
			addChild(topBK);
			topBK.addEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
			
			closeButton = ButtonFactory.CloseButton();
			addChild(closeButton);
			closeButton.x = topBK.width + topBK.x - closeButton.width;
			closeButton.y = 20;
			closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
			
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
			masker.scrollRect = new Rectangle(0, 0, topBK.width - 90, 40);
			leftArrow = ButtonFactory.TimingArrow(1);
			addChild(leftArrow);
			leftArrow.x = 30;
			leftArrow.y = topBK.height + 30;
			
			rightArrow = ButtonFactory.TimingArrow(-1);
			addChild(rightArrow);
			rightArrow.x = background.width - rightArrow.width + 5;
			rightArrow.y = leftArrow.y;
			timeButtons = new Vector.<Button>();
			for(var i:int = 0; i<24; i++){
				var btn:Button = ButtonFactory.WhiteButton();
				btn.setStyle("textFormat", Widget.normalFormat);
				btn.setStyle("disabledTextFormat", Widget.normalFormat);
				var str:String = "AM";
				if(i >= 12) str = "PM";
				btn.label = i + str;
				btn.name = i + "";
				btn.width = 50;
				timeButtons.push(btn);
				btn.x = buttonContainer.numChildren * (btn.width + 11);
				buttonContainer.addChild(btn);
				btn.toggle = true;
				btn.addEventListener(MouseEvent.CLICK, showCurrentTimingWeibo);
			}
			masker.addChild(buttonContainer);
			addChild(masker);
			masker.x = leftArrow.x + leftArrow.width + 10;
			masker.y = leftArrow.y;
			
			drawLine();
			addChild(hline);
			
			leftArrow.addEventListener(MouseEvent.CLICK, leftButton_mouseClickHandler);
			rightArrow.addEventListener(MouseEvent.CLICK, rightButton_mouseClickHandler);
			
			timeline = new ScaleBitmap((new Resource.Timeline() as Bitmap).bitmapData, "auto", true);
			timeline.scale9Grid = new Rectangle(7, 0, 16, 10);
			timeline.width = 620;
			addChild(timeline);
			timeline.x = 54;
			timeline.y = 280;
			
			if(!buttonGroup) buttonGroup = new WeiboPublisherButtonGroup();
			if(!imageViewer) imageViewer = new UploadImageViewer(100);
			if(!inputTextField) inputTextField = new TextField();
			if(!textNumText) textNumText = new TextField();
			
			addChild(imageViewer);
			imageViewer.x = 30;
			imageViewer.y = background.height - imageViewer.height - 20 + background.y;
			
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
			textNumText.y = bk.y + bk.height - textNumText.height - 5;
			
			inputTextField = new TextField();
			inputTextField.defaultTextFormat = new TextFormat(Widget.systemFont, 14, 0x4c4c4c, null, null, null, null, null, null, null, null, null, 5);
			inputTextField.type = TextFieldType.INPUT;
			inputTextField.wordWrap = true;
			inputTextField.multiline = true;
			addChild(inputTextField);
			inputTextField.x = bk.x + 10;
			inputTextField.y = bk.y + 10;
			inputTextField.width = bk.width + bk.x - inputTextField.x - 10;
			inputTextField.height = bk.height - 20;
			inputTextField.addEventListener(Event.CHANGE, inputTextField_onChangeHandler);
			inputTextField.addEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
			inputTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			addChild(buttonGroup);
			buttonGroup.gap = 36;
			buttonGroup.setSize(10, 70);
			buttonGroup.init();
			buttonGroup.x = bk.x;
			buttonGroup.y = bk.height + bk.y - 20;
			buttonGroup.addEventListener(MewEvent.SCREEN_SHOT, screenShotHandler);
			buttonGroup.addEventListener(MewEvent.EMOTION, emotionHandler);
			buttonGroup.addEventListener(MewEvent.TOPIC, topicHandler);
			buttonGroup.addEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
			buttonGroup.addEventListener(MewEvent.SHORT_URL, shortURLHandler);
			
			timeSettor = new TimeSettor();
			addChild(timeSettor);
			timeSettor.x = bk.x + bk.width + 10;
			timeSettor.y = bk.y;
			
			sendButton = ButtonFactory.WhiteButton();
			sendButton.setStyle("textFormat", new TextFormat(Widget.systemFont, 16, 0x4c4c4c, true));
			sendButton.label = "发 送";
			sendButton.width = 100;
			sendButton.height = 40;
			addChild(sendButton);
			sendButton.x = (timeSettor.width - sendButton.width) / 2 + timeSettor.x - 10;
			sendButton.y = (background.height + 110 + timeSettor.y) / 2 - sendButton.height / 2 - 5;
			sendButton.addEventListener(MouseEvent.CLICK, sendButton_mouseClickHandler);
			
			pointContainer = new Sprite();
			addChild(pointContainer);
			
			this.stage.focus = inputTextField;
			
			var now:Date = new Date();
			var year:Number = now.getFullYear();
			var month:Number = now.getMonth() + 1;
			var day:Number = now.getDate();
			var curHour:Number = now.getHours();
			
			TweenPlugin.activate([ShortRotationPlugin, TransformAroundCenterPlugin, TransformAroundPointPlugin]);
			
			curMillisecond = new Date(year, month - 1, day, 0, 0, 0, 0).time;
			curDay = day;
			curMonth = month;
			curYear = year;
			
			timeButtons[curHour].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			var curTabPosX:int = timeButtons[curHour].x;
			var times:int = int(curTabPosX / masker.scrollRect.width);
			var targetX:int = buttonContainer.x - times * masker.scrollRect.width <= -(buttonContainer.width - masker.scrollRect.width) ?
			 -(buttonContainer.width - masker.scrollRect.width) : buttonContainer.x - times * masker.scrollRect.width;
			 buttonContainer.x = targetX;
			 
			 curDateSelector = ButtonFactory.TimingComboBox();
			 curDateSelector.setStyle("textFormat", Widget.normalFormat);
			 curDateSelector.setSize(100, curDateSelector.height);
			 addChild(curDateSelector);
			 curDateSelector.x = 30;
			 curDateSelector.y = 115;
			 curDateSelector.addEventListener(Event.CHANGE, loadSelectedData);
			 
			 var obj:Object = MewSystem.app.timingWeiboManager.readDate();
			 if(obj){
				var dp:DataProvider = new DataProvider();
				for(var key:String in obj){
					dp.addItem({label: key, data: obj[key]["time"]});
				}
				dp.sortOn("data", [Array.DESCENDING, Array.NUMERIC]);
				curDateSelector.dataProvider = dp;
				var monthStr:String = curMonth < 10 ? "0" + curMonth : curMonth + "";
				var dayStr:String = curDay < 10 ? "0" + curDay : curDay + "";
				var timeStr:String = curYear + "-" + monthStr + "-" + dayStr;
				var index:int = 0;
				var len:int = dp.length;
				for(var k:int = 0; k<len; k++){
					if(dp.getItemAt(k).label == timeStr){
						index = k;
						break;
					}
				}
				curDateSelector.selectedIndex = index;
			 }
		}

		private function loadSelectedData(event : Event) : void
		{
			curMillisecond = curDateSelector.selectedItem.data;
			var date:Date = new Date(curMillisecond);
			curYear = date.getFullYear();
			curMonth = date.getMonth() + 1;
			curDay = date.getDate();
			removeAllPoint();
			closeDetailWindow();
			if(preTab) getCurrentData(int(preTab.name));
		}

		private function showCurrentTimingWeibo(event : MouseEvent) : void
		{
			var btn:Button = event.currentTarget as Button;
			if(preTab){
				if(preTab == btn){
					preTab.enabled = false;
					return;
				}
				preTab.enabled = true;
				preTab.toggle = false;
				preTab.toggle = true;
			}
			preTab = btn;
			removeAllPoint();
			closeDetailWindow();
			getCurrentData(int(btn.name));
		}

		private function getCurrentData(startHour:int) : void
		{
			minTime = curMillisecond + startHour * 3600000;
			maxTime = minTime + 3600000;
			perSize = timeline.width / 3600000;
			MewSystem.app.timingWeiboManager.target = this;
			MewSystem.app.timingWeiboManager.readData(minTime, maxTime, false);
		}

		private function closeWindow(event : MouseEvent) : void
		{
			MewSystem.app.closeTimingWindow();
		}

		private function sendButton_mouseClickHandler(event : MouseEvent) : void
		{
			if(Number(textNumText.text) < 0){
				MewSystem.showLightAlert("定时微博的字数不得大于140字!", container);
				return;
			}else if(Number(textNumText.text) >= 140){
				if(imageViewer.imageExtension){
					inputTextField.text = "分享图片";
				}else{
					MewSystem.showLightAlert("定时微博的内容不能为空!", container);
					return;
				}
			}
			var str:String = inputTextField.text;
			str = str.replace(/\s/g, " ");
			if(str == ""){
				if(imageViewer.imageExtension){
					inputTextField.text = "分享图片";
				}else{
					MewSystem.showLightAlert("定时微博的内容不能为空!", container);
					return;
				}
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
				if(targetTime - time > 60000){
					if(!MewSystem.app.timingWeiboManager.checkData(targetTime)){
						MewSystem.showLightAlert("该时间点已经存在定时任务!", container);
						return;
					}
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
					MewSystem.showLightAlert("定时微博的时间必需大于当前时间!", container);
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
			hline.graphics.lineStyle(2, 0x000000, .3);
			hline.graphics.moveTo(leftArrow.x, leftArrow.y + leftArrow.height + 12);
			hline.graphics.lineTo(rightArrow.x + rightArrow.width - 20, rightArrow.y + rightArrow.height + 10);
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
			emotionBtnPos.y = emotionBtnPos.y + buttonGroup.y - 5;
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
			urlShortor.parentStage = container;
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

		private function noSuggestion(event : MewEvent) : void
		{
			trace("no suggestion!");
			if(MewSystem.app.suggestor){
				if(container.contains(MewSystem.app.suggestor)) this.removeChild(MewSystem.app.suggestor);
				MewSystem.app.suggestor = null;
			}
			suggestGetter.removeEventListener(MewEvent.SUGGESTION_SUCCESS, suggestGetSuccess);
			suggestGetter.removeEventListener(MewEvent.SUGGESTION_FAILED, suggestGetFailed);
			suggestGetter.removeEventListener(MewEvent.NO_SUGGESTION, noSuggestion);
		}

		private function suggestGetFailed(event : MewEvent) : void
		{
			if(MewSystem.app.suggestor){
				if(container.contains(MewSystem.app.suggestor)) this.removeChild(MewSystem.app.suggestor);
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
		
		private function removeAllPoint():void
		{
			if(!pointList || !pointList.length) return;
			for each(var p:TimingPoint in pointList){
				p.removeEventListener(MouseEvent.MOUSE_OVER, swapOver);
				p.removeEventListener(MouseEvent.MOUSE_OUT, swapBack);
				pointContainer.removeChild(p);
			}
			pointList.length = 0;
		}
		
		public function timingWeiboData(data:Vector.<TimingWeiboVariable>):void
		{
			if(data && data.length){
				if(!pointList) pointList = new Vector.<TimingPoint>();
				for each(var item:TimingWeiboVariable in data){
					if(isInPointList(item)) continue;
					var pointTime:Number = item.time;
					var date:Date = new Date(pointTime);
					var hour:Number = date.getHours();
					if(preTab){
						if(int(preTab.name) != hour || !checkIsNow(pointTime)){
							continue;
						}
					}else{
						continue;
					}
					var point:TimingPoint = new TimingPoint();
					point.data = item;
					point.initPoint();
					pointContainer.addChild(point);
					point.scaleX = 0;
					point.scaleY = 0;
					point.index = pointContainer.numChildren - 1;
					TweenLite.to(point, .3, {transformAroundCenter:{scaleX:1, scaleY:1}, ease:Cubic.easeOut});
					point.x = int((item.time - minTime) * perSize) - point.width / 2 + timeline.x;
					point.y = timeline.y - point.height / 2 + timeline.height / 2;
					point.addEventListener(MouseEvent.MOUSE_OVER, swapOver);
					point.addEventListener(MouseEvent.MOUSE_OUT, swapBack);
					pointList.push(point);
				}
			}
		}
		
		private function checkIsNow(time:Number):Boolean
		{
			var date:Date = new Date(time);
			var year:Number = date.getFullYear();
			var month:Number = date.getMonth() + 1;
			var day:Number = date.getDate();
			if(year == curYear && month == curMonth && day == curDay) return true;
			return false;
		}
		
		public function isInPointList(data:TimingWeiboVariable):Boolean
		{
			if(pointList){
				for each(var point:TimingPoint in pointList){
					if(point.data && point.data.id == data.id) return true;
				}
			}
			return false;
		}

		private function swapBack(event : MouseEvent) : void
		{
			var target:TimingPoint = event.currentTarget as TimingPoint;
			pointContainer.setChildIndex(target, target.index);
		}

		private function swapOver(event : MouseEvent) : void
		{
			var target:TimingPoint = event.currentTarget as TimingPoint;
			pointContainer.setChildIndex(target, pointContainer.numChildren - 1);
			closeDetailWindow();
			detailWindow = new TimingDetailWindow(target.data);
			detailWindow.alpha = 0;
			TweenLite.to(detailWindow, .5, {alpha: 1});
			detailWindow.addEventListener(Event.CLOSE, closeDetailWindow);
			detailWindow.addEventListener(MewEvent.DELETE, deleteTimingWeibo);
			addChild(detailWindow);
			detailWindow.x = target.x + target.width / 2 - detailWindow.width / 2;
			if(detailWindow.x + detailWindow.width >= this.width){
				var num:int = detailWindow.moveTriangleRight();
				detailWindow.x = detailWindow.x - num;
			}else if(detailWindow.x <= 0){
				var lnum:int = detailWindow.moveTriangleLeft();
				detailWindow.x = detailWindow.x - lnum;
			}
			detailWindow.y = target.y - detailWindow.height - 5;
		}

		private function deleteTimingWeibo(event : MewEvent) : void
		{
			var detailWin:TimingDetailWindow = event.currentTarget as TimingDetailWindow;
			var timingData:TimingWeiboVariable = detailWin.data;
			if(container.contains(detailWin)) removeChild(detailWin);
			detailWin.removeEventListener(Event.CLOSE, closeDetailWindow);
			detailWin.removeEventListener(MewEvent.DELETE, deleteTimingWeibo);
			if(detailWindow == detailWin) detailWindow = null;
			var len:int = pointList.length;
			for(var i:int = 0; i<len; i++){
				var timingPoint:TimingPoint = pointList[i];
				if(timingPoint.data == timingData){
					if(container.contains(timingPoint)) TweenLite.to(timingPoint, .3, {transformAroundCenter:{scaleX:0, scaleY:0},
						 ease:Cubic.easeIn});
					timingPoint.mouseEnabled = false;
					timingPoint.mouseChildren = false;
					timingPoint.removeEventListener(MouseEvent.MOUSE_OVER, swapOver);
					timingPoint.removeEventListener(MouseEvent.MOUSE_OUT, swapBack);
					MewSystem.app.timingWeiboManager.deleteData(timingData.id, timingData.time);
					MewSystem.showLightAlert("定时微博删除成功!", container);
					timingPoint.data = null;
					return;
				}
			}
		}

		private function closeDetailWindow(event : Event = null) : void
		{
			if(detailWindow){
				if(container.contains(detailWindow)) container.removeChild(detailWindow);
				detailWindow.removeEventListener(Event.CLOSE, closeDetailWindow);
				detailWindow.removeEventListener(MewEvent.DELETE, deleteTimingWeibo);
				detailWindow = null;
			}
		}
		public function showLightAlert(str:String):void
		{
			MewSystem.showLightAlert(str, container);
		}
		
		private function drawTextBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .3);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, 300, 100, 12, 12);
			bk.graphics.endFill();
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h);
			addChildAt(whiteBackground, 1);
			whiteBackground.addEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
		}
		
		private function dragNativeWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
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
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(topBK){
				topBK.removeEventListener(MouseEvent.MOUSE_DOWN, dragNativeWindow);
				topBK = null;
			}
			titleText = null;
			if(leftArrow){
				leftArrow.removeEventListener(MouseEvent.CLICK, leftButton_mouseClickHandler);
				leftArrow = null;
			}
			if(rightArrow){
				rightArrow.removeEventListener(MouseEvent.CLICK, rightButton_mouseClickHandler);
				rightArrow = null;
			}
			masker = null;
			if(buttonContainer){
				buttonGroup.removeEventListener(MewEvent.SCREEN_SHOT, screenShotHandler);
				buttonGroup.removeEventListener(MewEvent.EMOTION, emotionHandler);
				buttonGroup.removeEventListener(MewEvent.TOPIC, topicHandler);
				buttonGroup.removeEventListener(MewEvent.CLEAR_CONTENT, clearContentHandler);
				buttonGroup.removeEventListener(MewEvent.SHORT_URL, shortURLHandler);
				buttonContainer = null;
			}
			timeButtons = null;
			hline = null;
			buttonGroup = null;
			imageViewer = null;
			bk = null;
			if(inputTextField){
				inputTextField.removeEventListener(Event.CHANGE, inputTextField_onChangeHandler);
				inputTextField.removeEventListener(Event.ADDED_TO_STAGE, inputTextField_addToStageHandler);
				inputTextField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				inputTextField = null;
			}
			textNumText = null;
			scroller = null;
			urlShortor = null;
			if(sendButton){
				sendButton.removeEventListener(MouseEvent.CLICK, sendButton_mouseClickHandler);
				sendButton = null;
			}
			timeline = null;
			timeSettor = null;
			if(suggestGetter){
				suggestGetter.dealloc();
				suggestGetter.removeEventListener(MewEvent.SUGGESTION_SUCCESS, suggestGetSuccess);
				suggestGetter.removeEventListener(MewEvent.SUGGESTION_FAILED, suggestGetFailed);
				suggestGetter.removeEventListener(MewEvent.NO_SUGGESTION, noSuggestion);
				suggestGetter = null;
			}
			if(MewSystem.app.suggestor){
				if(container && container.contains(MewSystem.app.suggestor)) this.removeChild(MewSystem.app.suggestor);
				MewSystem.app.suggestor = null;
			}
			if(closeButton){
				closeButton.removeEventListener(MouseEvent.CLICK, closeWindow);
				closeButton = null;
			}
			if(curDateSelector){
				curDateSelector.removeEventListener(Event.CHANGE, loadSelectedData);
				curDateSelector = null;
			}
			if(detailWindow){
				detailWindow.removeEventListener(Event.CLOSE, closeDetailWindow);
				detailWindow.removeEventListener(MewEvent.DELETE, deleteTimingWeibo);
				detailWindow = null;
			}
			pointContainer = null;
			preTab = null;
			removeAllPoint();
			pointList = null;
		}
	}
}