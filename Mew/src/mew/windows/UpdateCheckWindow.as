package mew.windows {
	import mew.modules.ProgressBar;

	import system.MewSystem;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;

	/**
	 * @author Abel Lee
	 */
	public class UpdateCheckWindow extends ALNativeWindow {
		private var progressBar:ProgressBar = null;
		public function UpdateCheckWindow(initOptions : NativeWindowInitOptions) {
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(200, 40);
			this.stage.nativeWindow.alwaysInFront = true;
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			progressBar = new ProgressBar();
			progressBar.showPercent(1);
			addChild(progressBar);
			progressBar.x = (background.width - 182) / 2 + 10;
			progressBar.y = (background.height - 20) / 2 + 10;
			
			MewSystem.app.checkUpdate();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			progressBar = null;
		}
	}
}
