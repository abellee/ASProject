package mew.windows {
	import mew.utils.StringUtils;
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
		public static var COMMENT:String = "comment";
		
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
		
		public function displayByState(state:String, userData:UserData = null, weiboData:WeiboData = null,
		 repostUserData:UserData = null, repostData:WeiboData = null):void
		{
			if(curContainer){
				removeChild(curContainer as UISprite);
				curContainer = null;
			}
			closeButton.x = whiteBackground.width;
			closeButton.y = 20;
			switch(state){
				case NORMAL:
					curContainer = new NormalStatePublisher();
					break;
				case COMMENT:
				case REPOST:
				case REPLY:
					curContainer = new ReplyOrRepostStatePublisher();
					closeButton.x = whiteBackground.width - 10;
					closeButton.y = 25;
					break;
				default:
					curContainer = new NormalStatePublisher();
					break;
			}
			currentState = state;
			if(userData && weiboData) curContainer.showWeiboContent(state, userData, weiboData, repostUserData, repostData);
			addChild(curContainer as UISprite);
			curContainer.x = 10;
			curContainer.y = 15;
			sendButton.x = background.x + background.width - sendButton.width - 20;
			sendButton.y = background.y + background.height - 65;
			sendButton.addEventListener(MouseEvent.CLICK, sendStatus);
			
			addChild(closeButton);
			
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
						var rid:String = curContainer.getWeiboData().id;
						var isComment:int = 0;
						if(content == null){
							MewSystem.showLightAlert("微博内容不能超过140个字!", container);
							return;
						}else if(content == ""){
							content = "转发微博";
						}
						if(curContainer.hasFirstCheckBox()){
							if(curContainer.getFirstSelect()){
								isComment = 1;
							}
						}
						if(curContainer.hasSecondCheckBox()){
							if(curContainer.getSecondSelect()){
								if(isComment) isComment = 3;
								else isComment = 2;
							}
						}
						MewSystem.app.alternationCenter.repostStatus(rid, content, isComment);
					}
					break;
				case COMMENT:
					if(curContainer){
						content = curContainer.getContent();
						if(content == null){
							MewSystem.showLightAlert("微博内容不能超过140个字!", container);
							return;
						}else if(content == ""){
							MewSystem.showLightAlert("微博内容不能为空!", container);
							return;
						}
						var ud:UserData = curContainer.getUserData();
						var wd:WeiboData = curContainer.getWeiboData();
						var rwd:WeiboData = curContainer.getRepostData();
						var sid:String = wd.id;
						var cid:String = wd.cid == null ? "0" : wd.cid;
						var commentOrigin:int = 0;
						if(curContainer.hasFirstCheckBox()){
							if(curContainer.getFirstSelect()){
								var str:String = content;
								if(rwd) str = str + "//@" + ud.username + ": " + wd.content;
								MewSystem.app.alternationCenter.repostStatus(sid, str, 0, false);
							}
						}
						if(curContainer.hasSecondCheckBox()){
							if(curContainer.getSecondSelect()){
								commentOrigin = 1;
							}
						}
						MewSystem.app.alternationCenter.commentStatus(sid, content, cid, commentOrigin);
					}
					break;
				case REPLY:
					if(curContainer){
						content = curContainer.getContent();
						if(content == null){
							MewSystem.showLightAlert("微博内容不能超过140个字!", container);
							return;
						}else if(content == ""){
							MewSystem.showLightAlert("微博内容不能为空!", container);
							return;
						}
						var uda:UserData = curContainer.getUserData();
						var wda:WeiboData = curContainer.getWeiboData();
						var rwda:WeiboData = curContainer.getRepostData();
						var sida:String = wda.id;
						var cida:String = wda.cid == null ? "0" : wda.cid;
						var commentText:String = "@" + wda.username + ":" + wda.commentText;
						var originNum:Number = StringUtils.getStringLength(commentText);
						var weiboTextNum:Number = StringUtils.getStringLength(content);
						var commentOrigina:int = 0;
						if(curContainer.hasFirstCheckBox()){
							if(curContainer.getFirstSelect()){
								var stra:String = content;
								if(originNum + weiboTextNum + 1 <= 140) stra = stra + "//" + commentText;
								MewSystem.app.alternationCenter.repostStatus(sida, stra, 0, false);
							}
						}
						if(curContainer.hasSecondCheckBox()){
							if(curContainer.getSecondSelect()){
								commentOrigina = 1;
							}
						}
						MewSystem.app.alternationCenter.commentStatus(sida, content, cida, commentOrigina);
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
			
			if(this.currentState != NORMAL && value == 1){
				displayByState(NORMAL);
			}
			
			MewSystem.showLightAlert(str, container);
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