package com.iabel.component {
	import mew.events.MewEvent;
	import mew.windows.ALNativeWindow;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class EmotionTextField extends UISprite {
		private var textField : TextField = null;
		private var indexArr : Array = null;

		public function EmotionTextField() {
			super();

			this.mouseEnabled = false;
			init();
		}

		override protected function onAdded(event : Event) : void {
			super.onAdded(event);

			if (!indexArr || !indexArr.length) return;
			var str : String = textField.text;
			var tempTF : TextField = new TextField();
			tempTF.defaultTextFormat = new TextFormat(Widget.systemFont, 12, null, null, null, null, null, null, null, null, null, null, 10);
			tempTF.autoSize = TextFieldAutoSize.LEFT;
			tempTF.mouseWheelEnabled = false;
			tempTF.wordWrap = true;
			tempTF.multiline = true;
			tempTF.text = str;
			tempTF.width = textField.width;
			tempTF.height = tempTF.textHeight;
			addChild(tempTF);
			tempTF.visible = false;

			while (indexArr.length) {
				var obj : Object = indexArr.pop();
				var rect : Rectangle = tempTF.getCharBoundaries(obj.index);
				var loader : Loader = new Loader();
				loader.load(new URLRequest(obj.url));
				addChild(loader);
				if (rect) {
					loader.x = rect.x + 2;
					loader.y = rect.y - 5;
				}
			}
			indexArr = null;
			removeChild(tempTF);
		}

		protected function init() : void {
			if (!textField) textField = new TextField();
			textField.styleSheet = Widget.linkStyle;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.mouseWheelEnabled = false;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.addEventListener(TextEvent.LINK, onTextLink);
			textField.addEventListener(MouseEvent.MOUSE_WHEEL, stopMouseWheel);
			textField.addEventListener(Event.SCROLL, stopScroll);
		}

		public function setText(str : String, value : Number, xml : XML) : void {
			textField.htmlText = str;
			textField.width = value - 10;
			textField.height = textField.textHeight;
			addChild(textField);
			emotionTranstion(textField, xml);
			setSize(value, textField.height);
		}

		protected function onTextLink(event : TextEvent) : void {
			var str : String = event.text;
			var arr : Array = str.split("|");
			if (arr && arr.length == 2) {
				var action : String = arr[0];
				var content : String = arr[1];
				switch(action) {
					case "at":
						if (this.stage && this.stage.nativeWindow && this.stage.nativeWindow is ALNativeWindow) MewSystem.showCycleLoading((this.stage.nativeWindow as ALNativeWindow).container);
						MewSystem.app.alternationCenter.loadUserTimeline(null, "0", content);
						break;
					case "topic":
						MewSystem.app.showSearchWindow(content);
						break;
					case "video":
						this.dispatchEvent(new MewEvent(MewEvent.PLAY_VIDEO));
						break;
				}
			}
		}

		public function replace(p : * = null, repl : * = null) : String {
			textField.htmlText = textField.htmlText.replace(p, repl);
			textField.height = textField.textHeight;
			if (this.height != textField.height) {
				setSize(textField.width, textField.height);
				this.dispatchEvent(new Event(Event.RESIZE));
			}
			return textField.htmlText;
		}

		public function text() : String {
			return textField.text;
		}

		protected function stopMouseWheel(event : MouseEvent) : void {
			textField.scrollV = 1;
		}

		protected function stopScroll(event : Event) : void {
			textField.scrollV = 1;
		}

		protected function emotionTranstion(tf : TextField, xml : XML) : void {
			var str : String = tf.htmlText;
			var pureStr : String = tf.text;
			var emotionPattern : RegExp = /\[[\u4e00-\u9fa5a-zA-Z\d]+?\]/g;
			var arr : Array = str.match(emotionPattern);
			indexArr = [];
			if (arr && arr.length) {
				var len : int = arr.length;
				for (var i : int = 0; i < len; i++) {
					var s : String = arr[i];
					var realIndex : int = pureStr.indexOf(s);
					var index : int = str.indexOf(s);
					var xmlList : XMLList = xml.children().(phrase == s).url;
					if (xmlList && (xmlList[0] is XML)) {
						var urlStr : String = xmlList[0].text();
						indexArr.push({url:urlStr, index:realIndex});
						var preStr : String = str.substring(0, index);
						var lastStr : String = str.substr(index + s.length);
						tf.htmlText = preStr + "　　" + lastStr;
						str = tf.htmlText;
						pureStr = tf.text;
					}
				}
			}
		}

		override protected function dealloc(event : Event) : void {
			super.dealloc(event);
			textField.removeEventListener(TextEvent.LINK, onTextLink);
			textField.removeEventListener(MouseEvent.MOUSE_WHEEL, stopMouseWheel);
			textField.removeEventListener(Event.SCROLL, stopScroll);
			textField = null;
			indexArr = null;
		}
	}
}