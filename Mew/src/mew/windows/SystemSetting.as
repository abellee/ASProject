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
	
	import system.MewSystem;
	
	import widget.Widget;
	
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
			this.stage.nativeWindow.alwaysInFront = true;
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			tabsGroup = new SystemSettingTabsGroup();
			enterButton = ButtonFactory.WhiteButton();
			cancelButton = ButtonFactory.WhiteButton();
			defaultButton = ButtonFactory.WhiteButton();
			enterButton.setStyle("textFormat", Widget.normalFormat);
			cancelButton.setStyle("textFormat", Widget.normalFormat);
			defaultButton.setStyle("textFormat", Widget.normalFormat);
			
			enterButton.label = "确 定";
			enterButton.width = 60;
			cancelButton.label = "取 消";
			cancelButton.width = 60;
			defaultButton.label = "恢复默认";
			defaultButton.width = 100;
			
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
			
			cancelButton.addEventListener(MouseEvent.CLICK, cancelButton_mouseClickHandler);
			enterButton.addEventListener(MouseEvent.CLICK, enterButton_mouseClickHandler);
			defaultButton.addEventListener(MouseEvent.CLICK, defaultButton_mouseClickHandler);
			
			drawDescriptionBackground();
			addChild(bk);
			bk.x = (this.width - bk.width) / 2;
			bk.y = tabsGroup.y + tabsGroup.height + 15;
			
			showContainer();
		}

		private function enterButton_mouseClickHandler(event : MouseEvent) : void
		{
			if(curContainer) curContainer.save();
			MewSystem.app.closeSystemSettingWindow();
		}

		private function cancelButton_mouseClickHandler(event : MouseEvent) : void
		{
			MewSystem.app.closeSystemSettingWindow();
		}
		private function defaultButton_mouseClickHandler(event:MouseEvent):void
		{
			if(curContainer) curContainer.setDefault();
		}
		private function systemTab_mouseClickHandler(event:MewEvent):void
		{
			trace(currentState);
			if(currentState == SYSTEM) return;
			currentState = SYSTEM;
			showContainer();
		}
		private function noticeTab_mouseClickHandler(event:MewEvent):void
		{
			trace(currentState);
			if(currentState == NOTICE) return;
			currentState = NOTICE;
			showContainer();
		}
		private function accountTab_mouseClickHandler(event:MewEvent):void
		{
			trace(currentState);
			if(currentState == ACCOUNT) return;
			currentState = ACCOUNT;
			showContainer();
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
			if(curContainer && container.contains(curContainer as UISprite)){
				curContainer.save();
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
		}
	}
}