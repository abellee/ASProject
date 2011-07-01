package mew.modules
{
	import com.iabel.core.ALSprite;
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.yahoo.astra.fl.containers.BorderPane;
	import com.yahoo.astra.layout.modes.BorderConstraints;
	
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class RepostBox extends DirectMessageBox
	{
		protected var timeAndFrom:TimeAndFrom = null;
		protected var imageBox:ImageBox = null;
		protected var videoBox:VideoBox = null;
		protected var musicBox:MusicBox = null;
		protected var videoChecker:VideoChecker = null;
		
		public function RepostBox()
		{
			super();
		}
//		protected function onResize(event:Event):void
//		{
//			/*if(imageBox){
//				timeAndFrom.x = imageBox.x;
//				timeAndFrom.y = imageBox.y + imageBox.height + 10;
////				trace(imageBox.height, nameBox.height, weiboText.height, timeAndFrom.height, this.height);
//			}
//			if(timeAndFrom){
//				var h:int = timeAndFrom.y + timeAndFrom.height;
//				if(h != this.height){
//					trace("改了");
//					setSize(this.width, h);
//				}
//			}
//			trace(this.height, "))))))))");
//			if(this.parent && parent is WeiboEntry) (parent as WeiboEntry).resize();*/
//		}
		
		override protected function init():void
		{
			super.init();
			timeAndFrom = new TimeAndFrom();
		}
		
		override public function initStatus(obj:Object):void
		{
			var status:MicroBlogStatus = obj as MicroBlogStatus;
			if(!status) return;
			userData = MewSystem.app.dataCache.getUserDataCache(status.user);
			data = MewSystem.app.dataCache.getWeiboDataCache(status);
			
			weiboText.htmlText = "<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(data.content) + "</span>";
			urls = StringUtils.getURLs(data.content);
			if(urls && urls.length){
				for each(var s:String in urls){
					var str:String = weiboText.htmlText;
					weiboText.htmlText = str.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
				}
				videoChecker = new VideoChecker();
				videoChecker.addEventListener(Event.COMPLETE, checkVideoUrlComplete);
				videoChecker.isVideoURL(urls);
			}
			
			if(data.content == "此微博已被原作者删除。"){
				nameBox = null;
				timeAndFrom = null;
				addChild(weiboText);
				weiboText.width = this.width;
				weiboText.height = weiboText.textHeight;
			}else{
				nameBox.userData = userData;
				nameBox.create();
				addChild(nameBox);
				
				addChild(weiboText);
				weiboText.x = nameBox.x;
				weiboText.y = nameBox.y + nameBox.height + 10;
				weiboText.width = this.width;
				weiboText.height = weiboText.textHeight;
				
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
			
		}
		protected function onResize(event:Event):void
		{
			var h:int = this.height;
			if(timeAndFrom){
				var index:int = this.getChildIndex(timeAndFrom);
				var preChild:DisplayObject = this.getChildAt(index - 1);
				timeAndFrom.y = preChild.y + preChild.height + 10;
				h = timeAndFrom.y + timeAndFrom.height;
			}
			setSize(this.width, h);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		protected function checkVideoUrlComplete(event:Event):void
		{
			videoChecker.removeEventListener(Event.COMPLETE, checkVideoUrlComplete);
			var urlsList:Array = videoChecker.videoURLs;
			if(weiboText){
				for each(var obj:Object in urlsList){
					if(obj.src){
						weiboText.htmlText = weiboText.htmlText.replace(new RegExp("<a href=\"" + obj.site + "\">" + obj.site + "</a>", "g"), "<a href='event:video|" + obj.src + "'>" + obj.site + "</a>");
					}
				}
			}
			videoChecker = null;
		}
	}
}