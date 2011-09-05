package mew.windows {
	import mew.data.SystemSettingData;
	import fl.controls.Button;

	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.factory.ButtonFactory;
	import mew.modules.IWeiboPublisherContainer;
	import mew.modules.NormalStatePublisher;
	import mew.modules.ReplyOrRepostStatePublisher;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class WeiBoPublisher extends ALNativeWindow
	{
		public static var NORMAL:String = "normal";
		public static var REPOST:String = "repost";
		public static var REPLY:String = "reply";
		
		private var currentState:String = NORMAL;
		private var curContainer:IWeiboPublisherContainer = null;
		private var closeButton:Button = null;
		private var sendButton:Button = null;
		public function WeiBoPublisher(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		override protected function init():void
		{
			drawBackground(640, 380);
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
			super.init();
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = Screen.mainScreen.visibleBounds.height + 10;
			
			if(!sendButton) sendButton = ButtonFactory.WhiteButton();
			sendButton.setStyle("textFormat", new TextFormat(Widget.systemFont, 16, 0x4c4c4c, true));
			sendButton.label = "发 送";
			sendButton.width = 100;
			sendButton.height = 40;
			addChild(sendButton);
			
			if(!closeButton) closeButton = ButtonFactory.CloseButton();
			addChild(closeButton);
			closeButton.x = whiteBackground.width;
			closeButton.y = 20;
			closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
		}

		private function closeWindow(event : MouseEvent) : void
		{
			MewSystem.app.closePublishWindow();
		}
		
		public function displayByState(state:String, userData:UserData = null, weiboData:WeiboData = null, additionalStr:String = null):void
		{
			if(curContainer){
				removeChild(curContainer as UISprite);
				curContainer = null;
			}
			switch(state){
				case NORMAL:
					curContainer = new NormalStatePublisher();
					break;
				case REPOST:
				case REPLY:
					curContainer = new ReplyOrRepostStatePublisher();
					break;
				default:
					curContainer = new NormalStatePublisher();
					break;
			}
			currentState = state;
			if(userData && weiboData) curContainer.showWeiboContent(state, userData, weiboData, additionalStr);
			addChild(curContainer as UISprite);
			curContainer.x = 10;
			curContainer.y = 15;
			sendButton.x = background.x + background.width - sendButton.width - 20;
			sendButton.y = background.y + background.height - 65;
			sendButton.addEventListener(MouseEvent.CLICK, sendStatus);
			
			TweenLite.to(this.stage.nativeWindow, .3, {y: Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height - 100});
		}
		
		private function sendStatus(event:MouseEvent):void
		{
			var content:String;
			var img:ByteArray;
			switch(currentState){
				case NORMAL:
					if(curContainer){
						content = curContainer.getContent();
						if(content == null){
							MewSystem.showLightAlert("微博内容不能超过140个字!", container);
							return;
						}
						img = curContainer.getImageData();
						if(img && content == ""){
							content = "分享图片";
						}else if(!img && content == ""){
							MewSystem.showLightAlert("微博内容不能为空!", container);
							return;
						}
						MewSystem.app.alternationCenter.updateStatus(content, img);
					}
					break;
				case REPOST:
					if(curContainer){
						content = curContainer.getContent();
						var rid:String = curContainer.getReplyId();
						var isComment:int = curContainer.isComment();
						if(content == null){
							MewSystem.showLightAlert("微博内容不能超过140个字!", container);
							return;
						}else if(content == ""){
							content = "转发微博";
						}
						MewSystem.app.alternationCenter.repostStatus(rid, content, isComment);
					}
					break;
				case REPLY:
					if(curContainer){
						content = curContainer.getContent();
						var sid:String = curContainer.getReplyId();
						var cid:String = curContainer.getCommentId();
						if(content == null){
							MewSystem.showLightAlert("微博内容不能超过140个字!", container);
							return;
						}else if(content == ""){
							MewSystem.showLightAlert("微博内容不能为空!", container);
							return;
						}
						MewSystem.app.alternationCenter.commentStatus(sid, content, cid);
					}
					break;
				default:
					return;
					break;
			}
			drawCover();
			MewSystem.showCycleLoading(container);
		}
		
		override public function showResult(value:int, mode:Boolean=false):void
		{
			if(container.contains(MewSystem.cycleMotion)) removeChild(MewSystem.cycleMotion);
			if(cover && container.contains(cover)){
				removeChild(cover);
				cover = null;
			}
			var str:String = "微博发布成功!";
			if(value == 0) str = "微博发布失败!";
			else curContainer.resetContent();
			
			MewSystem.showLightAlert(str, container);
			
			if(this.currentState != NORMAL){
				displayByState(NORMAL);
			}
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h);
			addChildAt(whiteBackground, 1);
			whiteBackground.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		private function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(closeButton) closeButton.removeEventListener(MouseEvent.CLICK, closeWindow);
			currentState = null;
			curContainer = null;
			closeButton = null;
		}
	}
}