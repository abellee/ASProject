package mew.windows {
	import flash.display.NativeWindowInitOptions;
	import flash.events.Event;

	/**
	 * @author Abel Lee
	 */
	public class TimingDetailWindow extends ALNativeWindow {
		public function TimingDetailWindow(initOptions : NativeWindowInitOptions) {
			super(initOptions);
		}
		override protected function init():void
		{
			
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
		}
	}
}
