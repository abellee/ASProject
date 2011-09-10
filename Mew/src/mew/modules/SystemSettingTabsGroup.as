package mew.modules
{
	import com.iabel.core.UISprite;
	
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	
	import widget.Widget;
	
	public class SystemSettingTabsGroup extends UISprite
	{
		private var systemSettingButton:Button = null;
		private var accountSettingButton:Button = null;
		private var noticeSettingButton:Button = null;
		public function SystemSettingTabsGroup()
		{
			super();
			
			init();
		}
		private function init():void
		{
			systemSettingButton = ButtonFactory.WhiteButton();
			noticeSettingButton = ButtonFactory.WhiteButton();
			accountSettingButton = ButtonFactory.WhiteButton();
			systemSettingButton.setStyle("textFormat", Widget.normalFormat);
			noticeSettingButton.setStyle("textFormat", Widget.normalFormat);
			accountSettingButton.setStyle("textFormat", Widget.normalFormat);
			
			systemSettingButton.label = "系统设置";
			systemSettingButton.width = 100;
			noticeSettingButton.label = "提示设置";
			noticeSettingButton.width = 100;
			accountSettingButton.label = "帐号设置";
			accountSettingButton.width = 100;
			
			addChild(systemSettingButton);
			addChild(noticeSettingButton);
			addChild(accountSettingButton);
			noticeSettingButton.x = systemSettingButton.x + systemSettingButton.width + 10;
			accountSettingButton.x = noticeSettingButton.x + noticeSettingButton.width + 10;
			
			setSize(accountSettingButton.x + accountSettingButton.width, accountSettingButton.height);
			
			systemSettingButton.addEventListener(MouseEvent.CLICK, systemSettingButton_mouseClickHandler);
			noticeSettingButton.addEventListener(MouseEvent.CLICK, noticeSettingButton_mouseClickHandler);
			accountSettingButton.addEventListener(MouseEvent.CLICK, accountSettingButton_mouseClickHandler);
		}
		private function systemSettingButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.SYSTEM));
		}
		private function noticeSettingButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.NOTICE));
		}
		private function accountSettingButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.ACCOUNT));
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			systemSettingButton.removeEventListener(MouseEvent.CLICK, systemSettingButton_mouseClickHandler);
			noticeSettingButton.removeEventListener(MouseEvent.CLICK, noticeSettingButton_mouseClickHandler);
			accountSettingButton.removeEventListener(MouseEvent.CLICK, accountSettingButton_mouseClickHandler);
			
			systemSettingButton = null;
			noticeSettingButton = null;
			accountSettingButton = null;
		}
	}
}