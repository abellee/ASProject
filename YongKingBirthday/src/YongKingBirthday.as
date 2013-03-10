package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import res.Resources;
	
	[SWF(width="990", height="760", frameRate="30")]
	public class YongKingBirthday extends Sprite
	{
		private var background:Bitmap = new (Resources.Background)();
		private var startButton:Sprite;
		private var gameDes:MovieClip = new (Resources.GameDescription)();
		
		public function YongKingBirthday()
		{
			addChild(background);
			
			startButton = new Sprite();
			var startButtonBitmap:Bitmap = new (Resources.StartButton)();
			startButton.addChild(startButtonBitmap);
			startButton.mouseChildren = false;
			startButton.buttonMode = true;
			startButton.addEventListener(MouseEvent.CLICK, startGame);
			addChild(startButton);
			startButton.x = (stage.stageWidth - startButton.width) / 2;
			startButton.y = (stage.stageHeight - startButton.height) / 2;
			
			addChild(gameDes);
			gameDes.play();
		}
		
		protected function startGame(event:MouseEvent):void
		{
			startButton.visible = false;
		}
		
		private function getTimeByNumber(num:int) : Bitmap
		{
			return null;
		}
	}
}