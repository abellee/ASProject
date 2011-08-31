package mew.windows {
	import fl.controls.Button;

	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.factory.ButtonFactory;
	import mew.modules.IWeiboPublisherContainer;
	import mew.modules.NormalStatePublisher;
	import mew.modules.ReplyOrRepostStatePublisher;

	import system.MewSystem;

	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			drawBackground(640, 400);
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = Screen.mainScreen.visibleBounds.height + 10;
			
			if(!sendButton) sendButton = ButtonFactory.SendButton();
			addChild(sendButton);
		}
		
		public function displayByState(state:String, userData:UserData = null, weiboData:WeiboData = null):void
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
			if(userData && weiboData) curContainer.showWeiboContent(state, userData, weiboData);
			addChild(curContainer as UISprite);
			curContainer.x = 10;
			curContainer.y = 10;
			sendButton.x = background.x + background.width - sendButton.width - 20;
			sendButton.y = background.y + background.height - 40;
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
							MewSystem.showLightAlert("微博内容不能超过140个字!", this.stage);
							return;
						}
						img = curContainer.getImageData();
						if(img && content == ""){
							content = "分享图片";
						}else if(!img && content == ""){
							MewSystem.showLightAlert("微博内容不能为空!", this.stage);
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
							MewSystem.showLightAlert("微博内容不能超过140个字!", this.stage);
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
							MewSystem.showLightAlert("微博内容不能超过140个字!", this.stage);
							return;
						}else if(content == ""){
							MewSystem.showLightAlert("微博内容不能为空!", this.stage);
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
			MewSystem.showCycleLoading(this.stage);
		}
		
		override public function showResult(value:int, mode:Boolean=false):void
		{
			if(this.stage.contains(MewSystem.cycleMotion)) removeChild(MewSystem.cycleMotion);
			if(cover && this.stage.contains(cover)){
				removeChild(cover);
				cover = null;
			}
			var str:String = "微博发布成功!";
			if(value == 0) str = "微博发布失败!";
			else curContainer.resetContent();
			
			MewSystem.showLightAlert(str, this.stage);
			
			if(this.currentState != NORMAL){
				displayByState(NORMAL);
			}
		}
		
		override protected function drawBackground(w:int, h:int):void
		{
			super.drawBackground(w, h);
			background.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		private function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			currentState = null;
			curContainer = null;
			closeButton = null;
		}
	}
}