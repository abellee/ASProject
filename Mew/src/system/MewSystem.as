package system {
	import config.Config;
	import config.SQLConfig;

	import mew.data.SuggestData;
	import mew.data.SystemSettingData;
	import mew.modules.Alert;
	import mew.modules.IEmotionCorrelation;
	import mew.modules.LightAlert;
	import mew.modules.OperationGroup;
	import mew.modules.Suggesttor;
	import mew.modules.ToolTip;
	import mew.windows.EmotionWindow;
	import mew.windows.LightNoticeWindow;

	import widget.Widget;

	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUnread;
	import com.sina.microblog.data.MicroBlogUser;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class MewSystem
	{
		public static var microBlog:MicroBlog = null;
		public static var app:Mew = null;
		
		public static var themeRes:Object = null;
		
		public static var lightAlert:LightAlert = null;
		public static var alert:Alert = null;
		
		public static var loadingMotion:MovieClip = new MovieClip();
		public static var cycleMotion:MovieClip = new MovieClip();
		
		public static var toolTip:ToolTip = null;
		public static var operationButton:OperationGroup = null;
		public static var repostOperationButton:OperationGroup = null;
		public static var noticeWindow:LightNoticeWindow = null;
		
		public static var database:Boolean = false;
		
		public static var lastStatusId:String = null;
		public static var lastDMId:String = null;
		public static var lastCommentId:String = null;
		public static var lastFanId:String = null;
		public static var lastAtId:String = null;
		
		public static var finalStatusId:String = null;
		public static var finalDMId:String = null;
		public static var finalCommentId:String = null;
		public static var finalFollowId:String = null;
		public static var finalCollectId:String = null;
		public static var finalUserStatusId:String = null;
		
		public static var statusNum:int = 20;
		public static var atNum:int = 20;
		public static var commentNum:int = 20;
		public static var userStatusNum:int = 20;
		public static var fansNum:int = 30;
		public static var followNum:int = 30;
		public static var directMessageNum:int = 20;        // totally is 40
		public static var collectNum:int = 20;
		public static var wbCommentNum:int = 10;
		
		public static var commentURL:String = "/statuses/comment.xml";
		public static var repostURL:String = "/statuses/repost.xml";
		
		public static function initMicroBlog():void
		{
			microBlog = new MicroBlog();
			microBlog.source = Config.appKey;
			microBlog.consumerKey = Config.appKey;
			microBlog.consumerSecret = Config.appSecret;
			microBlog.isTrustDomain = true;
		}
		
		public static function showNoticeWindow(data:MicroBlogUnread):void
		{
			if(!data.comments && !data.dm && !data.followers && !data.mentions && !data.new_status) return;
			if(!noticeWindow) noticeWindow = new LightNoticeWindow(getNativeWindowInitOption());
			noticeWindow.showNotice(data);
			noticeWindow.activate();
		}
		
		public static function closeNoticeWindow():void
		{
			if(noticeWindow){
				noticeWindow.close();
				noticeWindow = null;
			}
		}
		
		public static function getTriangle(dir:String = "up", size:int = 100):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(Widget.mainColor, 1.0);
			switch(dir){
				case "up":
					sp.graphics.moveTo(50, 0);
					sp.graphics.lineTo(0, 50);
					sp.graphics.lineTo(100, 50);
					sp.graphics.lineTo(50, 0);
					break;
				case "down":
					sp.graphics.moveTo(0, 0);
					sp.graphics.lineTo(size, 0);
					sp.graphics.lineTo(size / 2, size / 2);
					sp.graphics.lineTo(0, 0);
					break;
			}
			sp.graphics.endFill();
			return sp;
		}
		
		public static function checkLastId(fileName:String, arr:Array):Boolean
		{
			switch(fileName){
				case SQLConfig.MEW_FANS:
					return MewSystem.lastFanId == (arr[0] as MicroBlogUser).id;
					break;
				case SQLConfig.MEW_AT:
					return MewSystem.lastAtId == (arr[0] as MicroBlogStatus).id;
					break;
				case SQLConfig.MEW_DIRECT:
					return MewSystem.lastDMId == (arr[0] as MicroBlogDirectMessage).id;
					break;
				case SQLConfig.MEW_INDEX:
					return MewSystem.lastStatusId == (arr[0] as MicroBlogStatus).id;
					break;
				case SQLConfig.MEW_COMMENT:
					return MewSystem.lastCommentId == (arr[0] as MicroBlogComment).id;
					break;
				default:
					return true;
					break;
			}
		}
		
		public static function setLastId(fileName:String, arr:Array):void
		{
			switch(fileName){
				case SQLConfig.MEW_FANS:
					MewSystem.lastFanId = (arr[0] as MicroBlogUser).id;
					break;
				case SQLConfig.MEW_AT:
					MewSystem.lastAtId = (arr[0] as MicroBlogStatus).id;
					break;
				case SQLConfig.MEW_DIRECT:
					MewSystem.lastDMId = (arr[0] as MicroBlogDirectMessage).id;
					break;
				case SQLConfig.MEW_INDEX:
					MewSystem.lastStatusId = (arr[0] as MicroBlogStatus).id;
					break;
				case SQLConfig.MEW_COMMENT:
					MewSystem.lastCommentId = (arr[0] as MicroBlogComment).id;
					break;
			}
		}
		
		public static function setFinalId(fileName:String, arr:Array):void
		{
			switch(fileName){
				case SQLConfig.MEW_FOLLOW:
					MewSystem.finalFollowId = (arr[arr.length - 1] as MicroBlogUser).id;
					break;
				case SQLConfig.MEW_COLLECT:
					MewSystem.finalCollectId = (arr[arr.length - 1] as MicroBlogStatus).id;
					break;
				case SQLConfig.MEW_DIRECT:
					MewSystem.finalDMId = (arr[arr.length - 1] as MicroBlogDirectMessage).id;
					break;
				case SQLConfig.MEW_INDEX:
					MewSystem.finalStatusId = (arr[arr.length - 1] as MicroBlogStatus).id;
					break;
				case SQLConfig.MEW_MY_WEIBO:
					MewSystem.finalUserStatusId = (arr[arr.length - 1] as MicroBlogStatus).id;
					break;
				case SQLConfig.MEW_COMMENT:
					MewSystem.finalCommentId = (arr[arr.length - 1] as MicroBlogComment).id;
					break;
			}
		}
		
		public static function dmNotice(num:int):void
		{
			if(SystemSettingData.dmNotice && num > 0) app.showUnread(app.DIRECT_MESSAGE, num);
		}
		
		public static function atNotice(num:int):void
		{
			if(SystemSettingData.atNotice && num > 0) app.showUnread(app.AT, num);
		}
		
		public static function fansNotice(num:int):void
		{
			if(SystemSettingData.fansNotice && num > 0) app.showUnread(app.FANS, num);
		}
		
		public static function statusNotice(num:int):void
		{
			if(SystemSettingData.weiboNotice && num > 0) app.showUnread(app.INDEX, num);
		}
		
		public static function commentNotice(num:int):void
		{
			if(SystemSettingData.commentNotice && num > 0) app.showUnread(app.COMMENT, num);
		}
		
		public static function show(text:String, parent:DisplayObjectContainer):void
		{
			if(!parent.contains(alert)) parent.addChild(alert);
			alert.show(text);
		}
		
		public static function showLightAlert(str:String, parent:DisplayObjectContainer):void
		{
			if(!lightAlert) lightAlert = new LightAlert();
			parent.addChild(lightAlert);
			lightAlert.center(parent);
			lightAlert.show(str);
		}
		
		public static function showCycleLoading(parent:DisplayObjectContainer):void
		{
			Widget.widgetGlowFilter(MewSystem.cycleMotion, 5, 5);
			parent.addChild(MewSystem.cycleMotion);
			MewSystem.cycleMotion.x = (parent.width - MewSystem.cycleMotion.width) / 2;
			MewSystem.cycleMotion.y = (parent.height - MewSystem.cycleMotion.height) / 2;
		}
		
		public static function removeCycleLoading(parent:DisplayObjectContainer):void
		{
			if(!parent){
				if(MewSystem.cycleMotion.parent){
					MewSystem.cycleMotion.parent.removeChild(MewSystem.cycleMotion);
					return;
				}
				return;
			}
			if(parent.contains(MewSystem.cycleMotion)) parent.removeChild(MewSystem.cycleMotion);
		}
		
		public static function openEmotionWindow(pos:Point, parent:IEmotionCorrelation):void
		{
			if(!app.emotionWindow) app.emotionWindow = new EmotionWindow(getNativeWindowInitOption());
			app.emotionWindow.orientationWindow(pos);
			app.emotionWindow.targetWindow = parent;
			app.emotionWindow.activate();
		}
		
		public static function openSuggestWindow(pos:Point, data:Vector.<SuggestData>):void
		{
			if(!app.suggestor) app.suggestor = new Suggesttor();
			app.suggestor.locate(pos, data.length * 30);
			app.suggestor.showSuggest(data);
		}
		
		public static function closeEmotionWindow():void
		{
			if(app.emotionWindow){
				app.emotionWindow.close();
				app.emotionWindow = null;
			}
		}
		
		public static function getNativeWindowInitOption():NativeWindowInitOptions
		{
			var nativeWindowInitOption:NativeWindowInitOptions = new NativeWindowInitOptions();
			nativeWindowInitOption.systemChrome = "none";
			nativeWindowInitOption.transparent = true;
			nativeWindowInitOption.type = NativeWindowType.LIGHTWEIGHT;
			
			return nativeWindowInitOption;
		}
		
		public static function getVerticalLine(value:int):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(1, 0x000000, .2);
			sp.graphics.moveTo(0, 0);
			sp.graphics.lineTo(0, value);
			return sp;
		}
		
		public static function getRoundRect(widthSize:int, heightSize:int, lineColor:Number = 0x000000, backgroundColor:Number = 0xffffff,
		 backgroundAlpha:int = 1.0, lineWeight:int = 1, lineAlpha:int = 1, leftTop:int = 5, rightTop:int = 5, leftBottom:int = 5, rightBottom:int = 5):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(lineWeight, lineColor, lineAlpha);
			sp.graphics.beginFill(backgroundColor, backgroundAlpha);
			sp.graphics.drawRoundRectComplex(0, 0, widthSize, heightSize, leftTop, rightTop, leftBottom, rightBottom);
			sp.graphics.endFill();
			
			return sp;
		}
	}
}