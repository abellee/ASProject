package mew.modules {
	import config.Config;

	import fl.controls.CheckBox;
	import fl.controls.NumericStepper;

	import mew.data.SystemSettingData;
	import mew.factory.ButtonFactory;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SystemSettingContainer extends UISprite implements ISystemSettingContainer
	{
		private var hideTop:CheckBox = null;
		private var autoRun:CheckBox = null;
		private var autoHide:CheckBox = null;
		private var hideLeft:CheckBox = null;
		private var hideRight:CheckBox = null;
		private var alwayInFront:CheckBox = null;
		
		private var updateDelayTip:TextField = null;
		private var updateDelayLabel:TextField = null;
		private var interfaceHideLabel:TextField = null;
		
		private var updateDelayStepper:NumericStepper = null;
		
		public function SystemSettingContainer()
		{
			super();
		}
		public function init():void
		{
			if(!autoRun) autoRun = ButtonFactory.SystemCheckBox();
			if(!hideTop) hideTop = ButtonFactory.SystemCheckBox();
			if(!autoHide) autoHide = ButtonFactory.SystemCheckBox();
			if(!hideLeft) hideLeft = ButtonFactory.SystemCheckBox();
			if(!hideRight) hideRight = ButtonFactory.SystemCheckBox();
			if(!alwayInFront) alwayInFront = ButtonFactory.SystemCheckBox();
			
			if(!updateDelayTip) updateDelayTip = new TextField();
			if(!updateDelayLabel) updateDelayLabel = new TextField();
			if(!interfaceHideLabel) interfaceHideLabel = new TextField();
			
			if(!updateDelayStepper) updateDelayStepper = ButtonFactory.SystemNummericStepper();
			
			var tf:TextFormat = new TextFormat(Widget.systemFont, 12, 0x4c4c4c);
			
			updateDelayLabel.defaultTextFormat = tf;
			updateDelayLabel.autoSize = TextFieldAutoSize.LEFT;
			updateDelayLabel.selectable = false;
			updateDelayLabel.mouseEnabled = false;
			updateDelayLabel.mouseWheelEnabled = false;
			updateDelayLabel.text = "检测更新周期: ";
			updateDelayLabel.width = updateDelayLabel.textWidth;
			updateDelayLabel.height = updateDelayLabel.textHeight;
			addChild(updateDelayLabel);
			addChild(updateDelayStepper);
			updateDelayStepper.minimum = 0;
			updateDelayStepper.maximum = 10;
			updateDelayStepper.value = 0;
			var h:int = Math.max(updateDelayLabel.height, updateDelayStepper.height);
			updateDelayLabel.y = (h - updateDelayLabel.height) / 2;
			updateDelayStepper.x = updateDelayLabel.x + updateDelayLabel.width + 5;
			updateDelayStepper.y = (h - updateDelayStepper.height) / 2;
			updateDelayTip.defaultTextFormat = tf;
			updateDelayTip.autoSize = TextFieldAutoSize.LEFT;
			updateDelayTip.selectable = false;
			updateDelayTip.mouseEnabled = false;
			updateDelayTip.mouseWheelEnabled = false;
			updateDelayTip.text = "(0-10天 0为启动时检测)";
			updateDelayTip.width = updateDelayTip.textWidth;
			updateDelayTip.height = updateDelayTip.textHeight;
			updateDelayTip.x = updateDelayStepper.x + updateDelayStepper.width + 5;
			updateDelayTip.y = updateDelayLabel.y;
			
			alwayInFront.label = "置顶窗口";
			autoHide.label = "自动隐藏主界面";
			autoRun.label = "开机运行Mew微博";
			
			addChild(alwayInFront);
			addChild(autoHide);
			addChild(autoRun);
			alwayInFront.x = updateDelayLabel.x;
			alwayInFront.y = h + 10;
			autoHide.x = alwayInFront.x;
			autoHide.y = alwayInFront.y + alwayInFront.height + 10;
			autoRun.x = autoRun.x;
			autoRun.y = autoHide.y + autoHide.height + 10;
			
			interfaceHideLabel.defaultTextFormat = tf;
			interfaceHideLabel.autoSize = TextFieldAutoSize.LEFT;
			interfaceHideLabel.selectable = false;
			interfaceHideLabel.mouseEnabled = false;
			interfaceHideLabel.mouseWheelEnabled = false;
			interfaceHideLabel.text = "主界面隐藏方向";
			interfaceHideLabel.width = interfaceHideLabel.textWidth;
			interfaceHideLabel.height = interfaceHideLabel.textHeight;
			
			hideLeft.label = "左";
			hideTop.label = "上";
			hideRight.label = "右";
			
			autoHide.addEventListener(Event.CHANGE, autoRun_changeHandler);
			hideLeft.addEventListener(Event.CHANGE, hideLeft_changeHandler);
			hideTop.addEventListener(Event.CHANGE, hideTop_changeHandler);
			hideRight.addEventListener(Event.CHANGE, hideRight_changeHandler);
			
			customSetting();
		}
		
		private function hideLeft_changeHandler(event:Event):void
		{
			if(hideLeft.selected){
				event.preventDefault();
				resetDirectCheckBox();
			}
			hideLeft.selected = true;
		}
		
		private function hideTop_changeHandler(event:Event):void
		{
			if(hideTop.selected){
				event.preventDefault();
				resetDirectCheckBox();
			}
			hideTop.selected = true;
		}
		
		private function hideRight_changeHandler(event:Event):void
		{
			if(hideRight.selected){
				event.preventDefault();
				resetDirectCheckBox();
			}
			hideRight.selected = true;
		}
		
		private function resetDirectCheckBox():void
		{
			hideLeft.selected = false;
			hideTop.selected = false;
			hideRight.selected = false;
		}
		
		private function autoRun_changeHandler(event:Event):void
		{
			if(autoHide.selected && !this.contains(interfaceHideLabel)){
				addInterfaceHideDirection();
				return;
			}else{
				removeDir();
			}
		}
		
		private function removeDir():void
		{
			if(this.contains(interfaceHideLabel)) removeChild(interfaceHideLabel);
			if(this.contains(hideLeft)) removeChild(hideLeft);
			if(this.contains(hideTop)) removeChild(hideTop);
			if(this.contains(hideRight)) removeChild(hideRight);
		}
		
		private function customSetting():void
		{
			updateDelayStepper.value = SystemSettingData.checkUpdateDelay;
			alwayInFront.selected = SystemSettingData.alwaysInfront;
			autoHide.selected = SystemSettingData.autoHide;
			autoRun.selected = SystemSettingData.autoRun;
			if(autoHide.selected) addInterfaceHideDirection();
			else removeDir();
		}
		
		private function addInterfaceHideDirection():void
		{
			addChild(interfaceHideLabel);
			addChild(hideLeft);
			addChild(hideTop);
			addChild(hideRight);
			interfaceHideLabel.x = autoRun.x;
			interfaceHideLabel.y = autoRun.y + autoRun.height + 10;
			hideLeft.x = interfaceHideLabel.x;
			hideLeft.y = interfaceHideLabel.y + interfaceHideLabel.height + 5;
			hideTop.x = hideLeft.x + hideLeft.width + 10;
			hideTop.y = hideLeft.y;
			hideRight.x = hideTop.x + hideTop.width + 10;
			hideRight.y = hideTop.y;
			resetDirectCheckBox();
			switch(SystemSettingData.hideDirection){
				case 0:
					hideLeft.selected = true;
					break;
				case 1:
					hideTop.selected = true;
					break;
				case 2:
					hideRight.selected = true;
					break;
				default:
					hideTop.selected = true;
					break;
			}
		}
		
		public function setDefault():void
		{
			updateDelayStepper.value = 0;
			alwayInFront.selected = true;
			autoHide.selected = true;
			autoRun.selected = false;
			addChild(interfaceHideLabel);
			addChild(hideLeft);
			addChild(hideTop);
			addChild(hideRight);
			interfaceHideLabel.x = autoRun.x;
			interfaceHideLabel.y = autoRun.y + autoRun.height + 10;
			hideLeft.x = interfaceHideLabel.x;
			hideLeft.y = interfaceHideLabel.y + interfaceHideLabel.height + 5;
			hideTop.x = hideLeft.x + hideLeft.width + 10;
			hideTop.y = hideLeft.y;
			hideRight.x = hideTop.x + hideTop.width + 10;
			hideRight.y = hideTop.y;
			hideTop.selected = true;
			hideLeft.selected = false;
			hideRight.selected = false;
		}
		
		public function get hideDir():int
		{
			if(!this.contains(interfaceHideLabel)) return -1;
			if(hideLeft.selected) return 0;
			if(hideTop.selected) return 1;
			if(hideRight.selected) return 2;
			return 1;
		}
		
		public function get updateDelay():int
		{
			return updateDelayStepper.value;
		}
		
		public function get alwaysInFront():Boolean
		{
			return alwayInFront.selected;
		}
		
		public function get isAutoHide():Boolean
		{
			return autoHide.selected;
		}
		
		public function get isAutoRun():Boolean
		{
			return autoRun.selected;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			autoRun.removeEventListener(Event.CHANGE, autoRun_changeHandler);
			hideLeft.removeEventListener(Event.CHANGE, hideLeft_changeHandler);
			hideTop.removeEventListener(Event.CHANGE, hideTop_changeHandler);
			hideRight.removeEventListener(Event.CHANGE, hideRight_changeHandler);
			
			hideTop = null;
			autoRun = null;
			autoHide = null;
			hideLeft = null;
			hideRight = null;
			alwayInFront = null;
			
			updateDelayTip = null;
			updateDelayLabel = null;
			interfaceHideLabel = null;
			
			updateDelayStepper = null;
		}
		
		/**
		 * for interface
		 */
		public function get isVoice():Boolean
		{
			return true;
		}
		
		public function save():void
		{
			var dir:int = 0;
			if(hideLeft.selected) dir = 0;
			else if(hideTop.selected) dir = 1;
			else if(hideRight.selected) dir = 2;
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			so.data.autoRun = autoRun.selected;
			so.data.hideDirection = dir;
			so.data.checkUpdateDelay = updateDelayStepper.value;
			so.data.autoHide = autoHide.selected;
			so.data.alwaysInfront = alwayInFront.selected;
			trace(so.data.autoRun);
			so.flush();
			trace("flush");
			
			SystemSettingData.autoRun = autoRun.selected;
			SystemSettingData.hideDirection = dir;
			SystemSettingData.checkUpdateDelay = updateDelayStepper.value;
			SystemSettingData.autoHide = autoHide.selected;
			SystemSettingData.alwaysInfront = alwayInFront.selected;
		}
		
		public function get isWBNotice():Boolean
		{
			return true;
		}
		
		public function get isAtNotice():Boolean
		{
			return true;
		}
		
		public function get isDMNotice():Boolean
		{
			return true;
		}
		
		public function get isFansComment():Boolean
		{
			return true;
		}
		
		public function get isCommentNotice():Boolean
		{
			return true;
		}
		
		public function get isAutoLogin():Boolean
		{
			return true;
		}
	}
}