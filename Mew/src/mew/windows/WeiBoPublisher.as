package mew.windows
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import mew.data.SystemSettingData;
	
	public class WeiBoPublisher extends ALNativeWindow
	{
		public function WeiBoPublisher(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		override protected function init():void
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
		}
	}
}