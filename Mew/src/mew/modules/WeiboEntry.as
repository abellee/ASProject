package mew.modules {
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;

	import system.MewSystem;

	import com.sina.microblog.data.MicroBlogStatus;

	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class WeiboEntry extends RepostBox
	{
		protected var repostBox:RepostBox = null;
		public function WeiboEntry()
		{
			super();
		}
		override protected function init():void
		{
			super.init();
			userAvatar = new Avatar();
		}
		override protected function removeOperationButton(event : MouseEvent) : void
		{
			if(MewSystem.operationButton && this.contains(MewSystem.operationButton)){
				this.removeChild(MewSystem.operationButton);
				MewSystem.operationButton = null;
			}
		}
		
		override protected function showOperationButton(event : MouseEvent) : void
		{
			MewSystem.operationButton = new OperationGroup();
			if(userData.id == MewSystem.app.userData.id){
				MewSystem.operationButton.showAllButtons();
			}else{
				MewSystem.operationButton.showCollectionButton();
				MewSystem.operationButton.showRepostButton();
				MewSystem.operationButton.showCommentButton();
				MewSystem.operationButton.calculateSize();
			}
			MewSystem.operationButton.sid = data.id;
			addChild(MewSystem.operationButton);
			MewSystem.operationButton.x = this.width - MewSystem.operationButton.width - 5;
		}
		override public function initStatus(obj:Object, xml:XML):void
		{
			var status:MicroBlogStatus = obj as MicroBlogStatus;
			if(!status) return;
			userData = MewSystem.app.dataCache.getUserDataCache(status.user);
			data = MewSystem.app.dataCache.getWeiboDataCache(status);
			
			userAvatar.userData = userData;
			userAvatar.loadAvatar();
			addChild(userAvatar);
			
			nameBox.userData = userData;
			nameBox.create();
			addChild(nameBox);
			nameBox.x = userAvatar.x + userAvatar.width + 10;
			nameBox.y = 0;
			
			addChild(weiboText);
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 10;
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
			weiboText.setText("<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(contentStr) + "</span>", this.width - weiboText.x, xml);
			
			timeAndFrom.time = status.createdAt;
			timeAndFrom.from = status.source;
			timeAndFrom.create();
			
			if(data.imageData){
				imageBox = new ImageBox();
				imageBox.setSize(10, 10);
				imageBox.data = data.imageData;
				imageBox.create();
				addChild(imageBox);
				imageBox.x = weiboText.x;
				imageBox.y = weiboText.y + weiboText.height + 10;
				imageBox.addEventListener(Event.RESIZE, onResize);
			}
			
			if(data.repostData){
				repostBox = new RepostBox();
				repostBox.setSize(this.width - weiboText.x, 10);
				repostBox.x = weiboText.x;
				repostBox.y = weiboText.y + weiboText.height + 10;
				repostBox.initStatus(status.repost, xml);
				addChild(repostBox);
				repostBox.addEventListener(Event.RESIZE, onResize);
			}
			
			var preChild:DisplayObject = this.getChildAt(this.numChildren - 1);
			timeAndFrom.x = preChild.x;
			timeAndFrom.y = preChild.y + preChild.height + 10;
			addChild(timeAndFrom);
			setSize(this.width, this.height);
			addListener();
		}

		override protected function onResize(event:Event):void
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
			}
			setSize(this.width, h);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			repostBox = null;
		}
	}
}