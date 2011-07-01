package mew.modules
{
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	
	import mew.factory.ButtonFactory;
	import mew.factory.StaticAssets;

	public class VideoBox extends ImageBox
	{
		protected var playBtn:Button = null;
		public function VideoBox()
		{
			super();
		}
		override protected function init():void
		{
			defaultBK = new Bitmap(StaticAssets.DefaultVideo);
			playBtn = ButtonFactory.PlayButton();
		}
	}
}