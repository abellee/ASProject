package system
{
	import com.sina.microblog.MicroBlog;
	
	import config.Config;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.geom.Point;
	
	import mew.modules.Alert;
	import mew.modules.IEmotionCorrelation;
	import mew.modules.LightAlert;
	import mew.modules.ToolTip;
	import mew.windows.EmotionWindow;
	
	import widget.Widget;

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
		
		public static function initMicroBlog():void
		{
			if(!microBlog) microBlog = new MicroBlog();
			microBlog.source = Config.appKey;
			microBlog.consumerKey = Config.appKey;
			microBlog.consumerSecret = Config.appSecret;
			microBlog.isTrustDomain = true;
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
		
		public static function openEmotionWindow(pos:Point, parent:IEmotionCorrelation):void
		{
			if(!app.emotionWindow) app.emotionWindow = new EmotionWindow(getNativeWindowInitOption());
			app.emotionWindow.orientationWindow(pos);
			app.emotionWindow.targetWindow = parent;
			app.emotionWindow.activate();
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
	}
}