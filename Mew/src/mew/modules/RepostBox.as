package mew.modules {
	import mew.data.MediaData;
	import mew.events.MewEvent;
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;

	import system.MewSystem;

	import widget.Widget;

	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogStatus;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class RepostBox extends DirectMessageBox
	{
		protected var timeAndFrom:TimeAndFrom = null;
		protected var imageBox:ImageBox = null;
		protected var videoBox:VideoBox = null;
		protected var musicBox:MusicBox = null;
		protected var videoChecker:VideoChecker = null;
		protected var repostFrame:Sprite = null;
		protected var repostTriangle:Sprite = null;
		protected var shapeContainer:Sprite = null;
		protected var weiboCount:TextField = null;
		protected var showWeiboCount:Boolean = false;
		
		public function RepostBox(showCount:Boolean = false)
		{
			showWeiboCount = showCount;
			super();
		}
		
		override protected function init():void
		{
			super.init();
			shapeContainer = new Sprite();
			addChild(shapeContainer);
			timeAndFrom = new TimeAndFrom();
		}
		
		override protected function removeOperationButton(event : MouseEvent) : void
		{
			if(MewSystem.repostOperationButton && this.contains(MewSystem.repostOperationButton)){
				this.removeChild(MewSystem.repostOperationButton);
				MewSystem.repostOperationButton = null;
			}
		}
		
		override protected function showOperationButton(event : MouseEvent) : void
		{
			MewSystem.repostOperationButton = new OperationGroup();
			if(userData.id == MewSystem.app.userData.id){
				MewSystem.repostOperationButton.showAllButtons();
			}else{
				MewSystem.repostOperationButton.showCollectionButton();
				MewSystem.repostOperationButton.showRepostButton();
				MewSystem.repostOperationButton.showCommentButton();
				MewSystem.repostOperationButton.showReadComment();
				MewSystem.repostOperationButton.calculateSize();
			}
			data.cid = "0";
			MewSystem.repostOperationButton.finalStep = finalStep;
			MewSystem.repostOperationButton.data = data;
			MewSystem.repostOperationButton.parentWin = parentWin;
			MewSystem.repostOperationButton.userData = userData;
			MewSystem.repostOperationButton.sid = data.id;
			MewSystem.repostOperationButton.parentBox = this;
			addChild(MewSystem.repostOperationButton);
			MewSystem.repostOperationButton.x = this.width - MewSystem.repostOperationButton.width - 10;
			MewSystem.repostOperationButton.y = 20;
		}
		
		public function setWeiboCount(data:MicroBlogCount):void
		{
			if(weiboCount){
				weiboCount.text = "转发(" + data.repostsCount + ") | 评论(" + data.commentsCount + ")";
				weiboCount.width = weiboCount.textWidth;
				weiboCount.height = weiboCount.textHeight;
				weiboCount.x = weiboText.x + weiboText.width - weiboCount.width;
				weiboCount.y = timeAndFrom.y;
				addChild(weiboCount);
			}
		}
		
		override public function initStatus(obj:Object, xml:XML):void
		{
			var status:MicroBlogStatus = obj as MicroBlogStatus;
			if(!status) return;
			
			if(!status.user){
				nameBox = null;
				timeAndFrom = null;
				addChild(weiboText);
				weiboText.x = 10;
				weiboText.y = 20;
				weiboText.setText("<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt("该微博已被删除") + "</span>", this.width - 20, xml);
			}else{
				if(showWeiboCount){
					weiboCount = new TextField();
					weiboCount.defaultTextFormat = Widget.normalGrayFormat;
					weiboCount.autoSize = TextFieldAutoSize.LEFT;
					weiboCount.selectable = false;
					weiboCount.mouseEnabled = false;
				}
				userData = MewSystem.app.dataCache.getUserDataCache(status.user);
				data = MewSystem.app.dataCache.getWeiboDataCache(status);
				
				var contentStr:String = data.content.replace(/\</g, "&lt;");
				urls = StringUtils.getURLs(contentStr);
				if(urls && urls.length){
					for each(var s:String in urls){
						contentStr = contentStr.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
					}
					videoChecker = new VideoChecker();
					videoChecker.addEventListener(Event.COMPLETE, checkVideoUrlComplete);
					videoChecker.isVideoURL(urls);
				}
				nameBox.userData = userData;
				nameBox.create();
				nameBox.x = 10;
				nameBox.y = 20;
				addChild(nameBox);
				
				addChild(weiboText);
				weiboText.x = nameBox.x;
				weiboText.y = nameBox.y + nameBox.height + 10;
				weiboText.setText("<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(contentStr) + "</span>", this.width - 20, xml);
				
				timeAndFrom.time = status.createdAt;
				timeAndFrom.from = status.source;
				timeAndFrom.create();
				
				if(data.imageData){
					imageBox = new ImageBox();
					imageBox.data = data.imageData;
					addChild(imageBox);
					imageBox.create();
					imageBox.x = weiboText.x;
					imageBox.y = weiboText.y + weiboText.height + 10;
					imageBox.addEventListener(Event.RESIZE, onResize);
				}
				
				var preChild:DisplayObject = this.getChildAt(this.numChildren - 1);
				timeAndFrom.x = preChild.x;
				timeAndFrom.y = preChild.y + preChild.height + 10;
				addChild(timeAndFrom);
			}
			setSize(this.width, this.height);
			
			if(!repostTriangle) repostTriangle = MewSystem.getTriangle("up", 30, 0xFFFFFF);
			drawFrame();
			shapeContainer.addChild(repostTriangle);
			shapeContainer.addChild(repostFrame);
			repostFrame.y = 10;
			Widget.widgetGlowFilter(shapeContainer, 5, 5);
			addListener();
//			userData = MewSystem.app.dataCache.getUserDataCache(status.user);
//			data = MewSystem.app.dataCache.getWeiboDataCache(status);
//			
//			var contentStr:String = data.content.replace(/\</g, "&lt;");
//			urls = StringUtils.getURLs(contentStr);
//			if(urls && urls.length){
//				for each(var s:String in urls){
//					contentStr = contentStr.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
//				}
//				videoChecker = new VideoChecker();
//				videoChecker.addEventListener(Event.COMPLETE, checkVideoUrlComplete);
//				videoChecker.isVideoURL(urls);
//			}
//			weiboText.setText("<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(contentStr) + "</span>", this.width, xml);
//			
//			if(data.content == "此微博已被原作者删除。"){
//				nameBox = null;
//				timeAndFrom = null;
//				addChild(weiboText);
//			}else{
//				nameBox.userData = userData;
//				nameBox.create();
//				addChild(nameBox);
//				
//				addChild(weiboText);
//				weiboText.x = nameBox.x;
//				weiboText.y = nameBox.y + nameBox.height + 10;
//				
//				timeAndFrom.time = status.createdAt;
//				timeAndFrom.from = status.source;
//				timeAndFrom.create();
//				
//				if(data.imageData){
//					imageBox = new ImageBox();
//					imageBox.data = data.imageData;
//					addChild(imageBox);
//					imageBox.create();
//					imageBox.x = weiboText.x;
//					imageBox.y = weiboText.y + weiboText.height + 10;
//					imageBox.addEventListener(Event.RESIZE, onResize);
//				}
//				
//				var preChild:DisplayObject = this.getChildAt(this.numChildren - 1);
//				timeAndFrom.x = preChild.x;
//				timeAndFrom.y = preChild.y + preChild.height + 10;
//				addChild(timeAndFrom);
//			}
//			setSize(this.width, this.height);
//			addListener();
		}

		private function drawFrame() : void
		{
			if(!repostFrame) repostFrame = new Sprite();
			repostFrame.graphics.clear();
			repostFrame.graphics.beginFill(0xFFFFFF, 1.0);
			repostFrame.graphics.drawRect(0, 0, this.width - 2, this.height);
			repostFrame.graphics.endFill();
		}
		
		protected function onResize(event:Event):void
		{
			var h:int = this.height;
			if(timeAndFrom){
				var index:int = this.getChildIndex(timeAndFrom);
				var preChild:DisplayObject = this.getChildAt(index - 1);
				var preH:int = preChild.height;
				if(videoBox){
					var xpos:int = weiboText.x;
					var ypos:int = weiboText.y + weiboText.height + 10;
					if(imageBox){
						xpos = imageBox.x + imageBox.width + 10;
						ypos = imageBox.y;
						preH = Math.max(videoBox.height, imageBox.height);
					}
					videoBox.x = xpos;
					videoBox.y = ypos;
				}
				timeAndFrom.y = preChild.y + preH + 10;
				h = timeAndFrom.y + timeAndFrom.height;
				if(weiboCount){
					addChild(weiboCount);
					weiboCount.x = weiboText.x + weiboText.width - weiboCount.width;
					weiboCount.y = timeAndFrom.y;
				}
			}
			setSize(this.width, h);
			drawFrame();
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		protected function checkVideoUrlComplete(event:Event):void
		{
			videoChecker.removeEventListener(Event.COMPLETE, checkVideoUrlComplete);
			var urlsList:Array = videoChecker.videoURLs;
			if(weiboText){
				for each(var obj:Object in urlsList){
					if(obj.src){
						weiboText.replace(new RegExp("<a href=\"" + obj.site + "\">" + obj.site + "</a>", "g"), "<a href='event:video|" + obj.src + "'>" + obj.site + "</a>");
						if(!videoBox){
							videoBox = new VideoBox();
							var md:MediaData = new MediaData();
							md.thumbURL = obj.image;
							md.title = obj.title;
							md.originURL = obj.src;
							videoBox.data = md;
							videoBox.create();
							if(timeAndFrom){
								var index:int = this.getChildIndex(timeAndFrom);
								var xpos:int = weiboText.x;
								var ypos:int = weiboText.y + weiboText.height + 10;
								if(imageBox){
									xpos = imageBox.x + imageBox.width + 10;
									ypos = imageBox.y;
								}
								addChildAt(videoBox, index);
								videoBox.x = xpos;
								videoBox.y = ypos;
								videoBox.addEventListener(Event.RESIZE, onResize);
							}
						}
					}
				}
			}
			videoChecker = null;
		}
		
		override protected function playVideoHandler(event:MewEvent):void
		{
			if(videoBox) videoBox.play();
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			timeAndFrom = null;
			imageBox = null;
			videoBox = null;
			musicBox = null;
			if(videoChecker) videoChecker.removeEventListener(Event.COMPLETE, checkVideoUrlComplete);
			videoChecker = null;
			weiboCount = null;
		}
	}
}