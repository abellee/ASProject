package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	
	[SWF(width="592", height="595", frameRate="30")]
	public class Rounder extends Sprite
	{
		private var round:Round = new Round();
		private var pointer:Pointer = new Pointer();
		private var startButton:StartButton = new StartButton();
		private var background:Bitmap = new (Resources.Background)();
		
		private var result:int = 0;
		private var perCellAngle:int = 72;
		
		private var txt:TextField = new TextField();
		public function Rounder()
		{
			addChild(background);
			addChild(round);
			addChild(pointer);
			addChild(startButton);
			
			round.x = round.width / 2 + 9;
			round.y = round.height / 2 + 9;
			startButton.x = (stage.stageWidth - startButton.width) / 2 - 3;
			startButton.y = (stage.stageHeight - startButton.height) / 2 - 6;
			pointer.x = (stage.stageWidth - startButton.width) / 2 + 60;
			pointer.y = (stage.stageHeight - startButton.height) / 2 + 56;
			
			startButton.buttonMode = true;
			startButton.addEventListener(MouseEvent.CLICK, startGame);
			
			txt.border = true;
			txt.width = 100;
			txt.height = 40;
			txt.type = TextFieldType.INPUT;
			txt.restrict = "0-9";
			txt.background = true;
			addChild(txt);
		}
		
		protected function startGame(event:MouseEvent):void
		{	
			result = int(txt.text) - 1;
			if(result > 5 || result < 0){
				return;
			}
			startButton.buttonMode = false;
			startButton.removeEventListener(MouseEvent.CLICK, startGame);
			
			var addAngle:int = Math.random() * 360;
			TweenLite.to(round, 7, {rotation: - 360 * 10 - addAngle, ease:Circ.easeInOut})
			TweenLite.to(pointer, 8, {rotation: 360 * 10 - addAngle + result * perCellAngle + Math.random() * 50 + 10, onComplete:rotateComplete, ease:Circ.easeInOut});
		}
		
		private function rotateComplete():void
		{
			startButton.visible = true;
			startButton.buttonMode = true;
			startButton.addEventListener(MouseEvent.CLICK, startGame);
		}
	}
}