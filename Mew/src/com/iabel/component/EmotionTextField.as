package com.iabel.component
{
	import com.iabel.core.UISprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mew.utils.StringUtils;
	
	import org.bytearray.gif.player.GIFPlayer;
	
	import widget.Widget;
	
	public class EmotionTextField extends UISprite
	{
		private var textField:TextField = null;
		private var indexArr:Array = null;
		public function EmotionTextField()
		{
			super();
			
			this.mouseEnabled = false;
			init();
		}
		override protected function onAdded(event:Event):void{
			super.onAdded(event);
			
			if(!indexArr || !indexArr.length) return;
			var str:String = textField.text;
			var tempTF:TextField = new TextField();
			tempTF.defaultTextFormat = new TextFormat(Widget.systemFont, 12, null, null, null, null, null, null, null, null, null, null, 5);
			tempTF.autoSize = TextFieldAutoSize.LEFT;
			tempTF.mouseWheelEnabled = false;
			tempTF.wordWrap = true;
			tempTF.multiline = true;
			tempTF.text = str;
			tempTF.width = textField.width;
			tempTF.height = tempTF.textHeight;
			addChild(tempTF);
			tempTF.visible = false;
			
			while(indexArr.length){
				var obj:Object = indexArr.pop();
				var rect:Rectangle = tempTF.getCharBoundaries(obj.index - 1);
				var gifPlayer:GIFPlayer = new GIFPlayer();
				gifPlayer.load(new URLRequest(obj.url));
				addChild(gifPlayer);
				gifPlayer.x = rect.x + 2;
				gifPlayer.y = rect.y - 5;
			}
			indexArr = null;
			removeChild(tempTF);
		}
		protected function init():void
		{
			if(!textField) textField = new TextField();
			textField.styleSheet = Widget.linkStyle;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.mouseWheelEnabled = false;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.addEventListener(MouseEvent.MOUSE_WHEEL, stopMouseWheel);
			textField.addEventListener(Event.SCROLL, stopScroll);
		}
		public function setText(str:String, value:Number, xml:XML):void
		{
			textField.htmlText = str;
			textField.width = value - 10;
			textField.height = textField.textHeight;
			addChild(textField);
			emotionTranstion(textField, xml);
			setSize(value, textField.height);
		}
		public function replace(p:* = null, repl:* = null):String
		{
			textField.htmlText = textField.htmlText.replace(p, repl);
			textField.height = textField.textHeight;
			if(this.height != textField.height){
				setSize(textField.width, textField.height);
				this.dispatchEvent(new Event(Event.RESIZE));
			}
			return textField.htmlText;
		}
		public function text():String
		{
			return textField.text;
		}
		protected function stopMouseWheel(event:MouseEvent):void
		{
			textField.scrollV = 1;
		}
		protected function stopScroll(event:Event):void
		{
			textField.scrollV = 1;
		}
		protected function emotionTranstion(tf:TextField, xml:XML):void
		{
			var str:String = tf.htmlText;
			var pureStr:String = tf.text;
			var emotionPattern:RegExp = /\[[\u4e00-\u9fa5a-zA-Z\d]+?\]/g;
			var arr:Array = str.match(emotionPattern);
			indexArr = [];
			if(arr && arr.length){
				var len:int = arr.length;
				for(var i:int = 0; i<len; i++){
					var s:String = arr[i];
					var realIndex:int = pureStr.search(s);
					var index:int = str.search(s);
					var xmlList:XMLList = xml.children().(phrase == s).url;
					if(xmlList && (xmlList[0] is XML)){
						var urlStr:String = xmlList[0].text();
						indexArr.push({url: urlStr, index: realIndex});
						var preStr:String = str.substring(0, index - 1);
						var lastStr:String = str.substr(index - 1 + s.length);
						tf.htmlText = preStr + "　　" + lastStr;
						str = tf.htmlText;
						pureStr = tf.text;
					}
				}
			}
		}
		
		override protected function dealloc(event:Event):void{
			super.dealloc(event);
			textField.removeEventListener(MouseEvent.MOUSE_WHEEL, stopMouseWheel);
			textField.removeEventListener(Event.SCROLL, stopScroll);
			textField = null;
		}
	}
}