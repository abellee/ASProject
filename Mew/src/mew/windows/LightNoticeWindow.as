package mew.windows {
	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogUnread;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Abel Lee
	 */
	public class LightNoticeWindow extends ALNativeWindow {
		private var txt:TextField = null;
		public function LightNoticeWindow(initOptions : NativeWindowInitOptions) {
			super(initOptions);
		}
		override protected function init():void
		{
			return;
		}
		public function showNotice(data:MicroBlogUnread):void
		{
			if(!txt) txt = new TextField();
			txt.defaultTextFormat = Widget.noticeFormat;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.mouseEnabled = false;
			
			var str:String = "";
			if(data.new_status) str += data.new_status + "条新微博\n";
			if(data.comments) str += data.comments + "条新评论\n";
			if(data.followers) str += data.followers + "位新粉丝\n";
			if(data.mentions) str += data.mentions + "条新转发\n";
			if(data.dm) str += data.dm + "封新私信";
			
			txt.text = str;
			txt.width = txt.textWidth;
			txt.height = txt.textHeight;
			addChild(txt);
			txt.x = 20;
			txt.y = 20;
			
			container.alpha = 0;
			drawBackground(txt.width + txt.x, txt.height + txt.y);
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			this.stage.nativeWindow.x = Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width;
			this.stage.nativeWindow.y = MewSystem.app.stage.nativeWindow.y + MewSystem.app.stage.nativeWindow.height - 10;
			
			TweenLite.to(container, .5, {alpha: 1, onComplete: showComplete});
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			if(!background) background = new UISprite();
			background.mouseChildren = false;
			background.graphics.clear();
			background.graphics.beginFill(Widget.mainColor, 1.0);
			background.graphics.drawRoundRect(10, 10, w, h, 20, 20);
			background.graphics.endFill();
			Widget.widgetGlowFilter(background);
			addChildAt(background, 0);
		}
		
		private function showComplete():void
		{
			TweenLite.to(container, .5, {alpha: 0, delay: 2, onComplete: closeSelf});
		}
		
		private function closeSelf():void
		{
			MewSystem.closeNoticeWindow();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			txt = null;
		}
	}
}
