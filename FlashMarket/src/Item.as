package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class Item extends Sprite
	{
		private var _keywords:Array = null;
		private var textField:TextField = null;
		private var _content:String = null;
		private var _pos:Point = null;
		private var _tid:int = 0;
		private var _rotate:Number = 0;
		private var _background:BitmapData = null;
		private var textBitmap:Bitmap = null;
		private var _index:int = -1;
		public function Item()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
		
		public function init():void
		{
			var bitmap:Bitmap = new Bitmap(_background);
			addChildAt(bitmap, 0);
			
			if(!textField) textField = new TextField();
			textField.defaultTextFormat = Cache.normalFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			textField.selectable = false;
			textField.text = _content;
			textField.width = bitmap.width;
			textField.height = bitmap.height;
			
			var bd:BitmapData = new BitmapData(textField.width, textField.height, true, 0x00000000);
			bd.draw(textField);
			textBitmap = new Bitmap(bd, "auto", true);
			
			addChild(textBitmap);
			
			textBitmap.x = (bitmap.width - textBitmap.width) / 2;
			textBitmap.y = (bitmap.height - textBitmap.height) / 2;
			
			if(textBitmap) textBitmap.rotation = _rotate;
			if(bitmap) bitmap.rotation = _rotate;
		}
		
		public function hasKeyword(str:String):Boolean
		{
			var num:int = _keywords.indexOf(str);
			if(num == -1) return false;
			else return true;
		}
		
		public function showInfoPanel(infoPanel:InfoPanel):void
		{
			addChild(infoPanel);
			var localPos:Point = this.globalToLocal(new Point(this.stage.mouseX, this.stage.mouseY));
			infoPanel.x = localPos.x;
			infoPanel.y = localPos.y;
		}
		
		public function removeInfoPanel(infoPanel:InfoPanel):void
		{
			if(this.contains(infoPanel)) removeChild(infoPanel);
		}
		
		private function dealloc(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			_keywords = null;
			while(this.numChildren) this.removeChildAt(0);
			textField = null;
			_pos = null;
			_content = null;
			if(_background) _background.dispose();
			if(textBitmap) textBitmap.bitmapData.dispose();
			textBitmap = null;
			_background = null;
			this.filters = null;
		}
		
		public function get keywords():Array
		{
			return _keywords;
		}

		public function set keywords(value:Array):void
		{
			_keywords = value;
		}

		public function get pos():Point
		{
			return _pos;
		}

		public function set pos(value:Point):void
		{
			_pos = value;
		}

		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
		}

		public function get tid():int
		{
			return _tid;
		}

		public function set tid(value:int):void
		{
			_tid = value;
		}

		public function get rotate():Number
		{
			return _rotate;
		}

		public function set rotate(value:Number):void
		{
			_rotate = value;
		}

		public function get background():BitmapData
		{
			return _background;
		}

		public function set background(value:BitmapData):void
		{
			_background = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}


	}
}