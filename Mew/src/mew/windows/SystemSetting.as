package mew.windows
{
	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	
	import fl.controls.Button;
	
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	import mew.modules.AccountSettingContainer;
	import mew.modules.ISystemSettingContainer;
	import mew.modules.NoticeSettingContainer;
	import mew.modules.SystemSettingContainer;
	import mew.modules.SystemSettingTabsGroup;
	
	public class SystemSetting extends ALNativeWindow
	{
		private var enterButton:Button = null;
		private var cancelButton:Button = null;
		private var defaultButton:Button = null;
		
		private var tabsGroup:SystemSettingTabsGroup = null;
		
		private var currentState:String = SYSTEM;
		
		private static var SYSTEM:String = "system";
		private static var ACCOUNT:String = "account";
		private static var NOTICE:String = "notice";
		
		private var bk:Sprite = null;
		
		private var curContainer:ISystemSettingContainer = null;
		
		public function SystemSetting(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		override protected function init():void
		{
			drawBackground(400, 350);
			background.alpha = 0;
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			TweenLite.to(background, .5, {alpha: 1});
			
			tabsGroup = new SystemSettingTabsGroup();
			enterButton = ButtonFactory.EnterButton();
			cancelButton = ButtonFactory.CancelButton();
			defaultButton = ButtonFactory.DefaultButton();
			
			addChild(tabsGroup);
			tabsGroup.addEventListener(MewEvent.SYSTEM, systemTab_mouseClickHandler);
			tabsGroup.addEventListener(MewEvent.NOTICE, noticeTab_mouseClickHandler);
			tabsGroup.addEventListener(MewEvent.ACCOUNT, accountTab_mouseClickHandler);
			tabsGroup.x = (this.width - tabsGroup.width) / 2;
			tabsGroup.y = 30;
			
			addChild(enterButton);
			addChild(cancelButton);
			addChild(defaultButton);
			
			enterButton.x = background.x + background.width - enterButton.width - 10;
			enterButton.y = background.y + background.height - enterButton.height - 10;
			cancelButton.x = enterButton.x - cancelButton.width - 10;
			cancelButton.y = enterButton.y;
			defaultButton.x = background.x + 30;
			defaultButton.y = enterButton.y;
			
			defaultButton.addEventListener(MouseEvent.CLICK, defaultButton_mouseClickHandler);
			
			drawDescriptionBackground();
			addChild(bk);
			bk.x = (this.width - bk.width) / 2;
			bk.y = tabsGroup.y + tabsGroup.height + 15;
			
			showContainer();
		}
		private function defaultButton_mouseClickHandler(event:MouseEvent):void
		{
			if(curContainer) curContainer.setDefault();
		}
		private function systemTab_mouseClickHandler(event:MewEvent):void
		{
			if(currentState == SYSTEM) return;
			currentState = SYSTEM;
			showContainer();
		}
		private function noticeTab_mouseClickHandler(event:MewEvent):void
		{
			if(currentState == NOTICE) return;
			currentState = NOTICE;
			showContainer();
		}
		private function accountTab_mouseClickHandler(event:MewEvent):void
		{
			if(currentState == ACCOUNT) return;
			currentState = ACCOUNT;
			showContainer();
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
		
		private function drawDescriptionBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .5);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, background.width - 40, background.height - tabsGroup.height - tabsGroup.y - enterButton.height - 40 + background.y, 12, 12);
			bk.graphics.endFill();
		}
		
		private function showContainer():void
		{
			if(curContainer && this.stage.contains(curContainer as UISprite)){
				removeChild(curContainer as UISprite);
				curContainer = null;
			}
			switch(currentState){
				case SYSTEM:
					curContainer = new SystemSettingContainer();
					break;
				case ACCOUNT:
					curContainer = new AccountSettingContainer();
					break;
				case NOTICE:
					curContainer = new NoticeSettingContainer();
					break;
			}
			curContainer.setSize(bk.width - 20, bk.height - 20);
			curContainer.init();
			addChild(curContainer as UISprite);
			curContainer.x = bk.x + 10;
			curContainer.y = bk.y + 10;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			defaultButton.removeEventListener(MouseEvent.CLICK, defaultButton_mouseClickHandler);
			enterButton = null;
			cancelButton = null;
			defaultButton = null;
			curContainer = null;
			bk = null;
			tabsGroup = null;
			currentState = null;
			SYSTEM = null;
			ACCOUNT = null;
			NOTICE = null;
		}
	}
}