package mew.modules
{
	import com.iabel.core.UISprite;
	
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	
	public class WeiboPublisherButtonGroup extends UISprite
	{
		private var screenShotButton:Button = null;
		private var shortURLButton:Button = null;
		private var emotionButton:Button = null;
		private var topicButton:Button = null;
		private var clearButton:Button = null;
		public var gap:int = 40;
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
			}
			if(!emotionButton) emotionButton = ButtonFactory.EmotionButton();
			if(!topicButton) topicButton = ButtonFactory.TopicButton();
			if(!clearButton) clearButton = ButtonFactory.ClearButton();
			if(!shortURLButton) shortURLButton = ButtonFactory.ShortURLButton();
			
			addChild(emotionButton);
			emotionButton.x = xpos;
			emotionButton.y = this.height - emotionButton.height;
			xpos = emotionButton.x + emotionButton.width + gap;
			addChild(topicButton);
			topicButton.x = xpos;
			topicButton.y = this.height - topicButton.height;
			xpos = topicButton.x + topicButton.width + gap;
			addChild(clearButton);
			clearButton.x = xpos;
			clearButton.y = this.height - clearButton.height;
			xpos = clearButton.x + clearButton.width + gap;
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