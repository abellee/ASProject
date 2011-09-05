package mew.modules {
	import fl.controls.Button;

	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;

	import system.MewSystem;

	import com.iabel.core.UISprite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class WeiboPublisherButtonGroup extends UISprite
	{
		private var screenShotButton:Button = null;
		private var shortURLButton:Button = null;
		private var emotionButton:Button = null;
		private var topicButton:Button = null;
		private var clearButton:Button = null;
		public var gap:int = 60;
		public function WeiboPublisherButtonGroup()
		{
			super();
		}
		public function init(bool:Boolean = true):void{
			var xpos:int = 0;
			if(bool && !screenShotButton){
				screenShotButton = ButtonFactory.ScreenShotButton();
				addChild(screenShotButton);
				xpos = screenShotButton.x + screenShotButton.width + gap;
				screenShotButton.y = this.height - screenShotButton.height;
				screenShotButton.addEventListener(MouseEvent.CLICK, screenShotButton_mouseClickHandler);
				var hline0:Sprite = MewSystem.getVerticalLine(20);
				addChild(hline0);
				hline0.x = screenShotButton.x + screenShotButton.width + gap / 2;
				hline0.y = this.height - hline0.height - 7;
			}
			if(!emotionButton) emotionButton = ButtonFactory.EmotionButton();
			if(!topicButton) topicButton = ButtonFactory.TopicButton();
			if(!clearButton) clearButton = ButtonFactory.ClearButton();
			if(!shortURLButton) shortURLButton = ButtonFactory.ShortURLButton();
			
			addChild(emotionButton);
			emotionButton.x = xpos;
			emotionButton.y = this.height - emotionButton.height;
			xpos = emotionButton.x + emotionButton.width + gap;
			var hline:Sprite = MewSystem.getVerticalLine(20);
			addChild(hline);
			hline.x = emotionButton.x + emotionButton.width + gap / 2;
			hline.y = this.height - hline.height - 7;
			addChild(topicButton);
			topicButton.x = xpos;
			topicButton.y = this.height - topicButton.height;
			xpos = topicButton.x + topicButton.width + gap;
			var hline1:Sprite = MewSystem.getVerticalLine(20);
			addChild(hline1);
			hline1.x = topicButton.x + topicButton.width + gap / 2;
			hline1.y = this.height - hline1.height - 7;
			addChild(clearButton);
			clearButton.x = xpos;
			clearButton.y = this.height - clearButton.height;
			xpos = clearButton.x + clearButton.width + gap;
			var hline2:Sprite = MewSystem.getVerticalLine(20);
			addChild(hline2);
			hline2.x = clearButton.x + clearButton.width + gap / 2;
			hline2.y = this.height - hline2.height - 7;
			addChild(shortURLButton);
			shortURLButton.x = xpos;
			shortURLButton.y = this.height - shortURLButton.height;
			xpos = shortURLButton.x + shortURLButton.width;
			
			emotionButton.addEventListener(MouseEvent.CLICK, emotionButton_mouseClickHandler);
			topicButton.addEventListener(MouseEvent.CLICK, topicButton_mouseClickHandler);
			clearButton.addEventListener(MouseEvent.CLICK, clearButton_mouseClickHandler);
			shortURLButton.addEventListener(MouseEvent.CLICK, shortURLButton_mouseClickHandler);
			
			setSize(xpos, this.height);
			
		}
		
		public function getShortButtonPos():Point
		{
			return new Point(shortURLButton.x + shortURLButton.width / 2, shortURLButton.y);
		}
		
		public function getEmotionButtonPos():Point
		{
			return new Point(emotionButton.x + emotionButton.width / 2, emotionButton.y);
		}
		
		private function screenShotButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.SCREEN_SHOT));
		}
		
		private function emotionButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.EMOTION));
		}
		
		private function topicButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.TOPIC));
		}
		
		private function clearButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.CLEAR_CONTENT));
		}
		
		private function shortURLButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.SHORT_URL));
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(screenShotButton) screenShotButton.removeEventListener(MouseEvent.CLICK, screenShotButton_mouseClickHandler);
			emotionButton.removeEventListener(MouseEvent.CLICK, emotionButton_mouseClickHandler);
			topicButton.removeEventListener(MouseEvent.CLICK, topicButton_mouseClickHandler);
			clearButton.removeEventListener(MouseEvent.CLICK, clearButton_mouseClickHandler);
			shortURLButton.removeEventListener(MouseEvent.CLICK, shortURLButton_mouseClickHandler);
			
			screenShotButton = null;
			shortURLButton = null;
			emotionButton = null;
			emotionButton = null;
			clearButton = null;
		}
	}
}