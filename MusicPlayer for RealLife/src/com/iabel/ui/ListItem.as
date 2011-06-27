package com.iabel.ui
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	import resource.UIResource;
	
	public class ListItem extends Sprite
	{
		private var cb:CheckBox;
		private var _title:TextField;
		private var _author:TextField;
		private var _id:Number;
		private var _url:String;
		private var _playingIcon:Bitmap;
		private var background:Sprite;
		public function ListItem()
		{
			super();
			init();
			addListener();
		}
		private function init():void{
			
			background = new Sprite();
			background.graphics.beginFill(0x0066ff, .3);
			background.graphics.drawRect(0, 0, 530, 30);
			background.graphics.endFill();
			addChild(background);
			background.alpha = 0;
			background.doubleClickEnabled = true;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x000000;
			textFormat.size = 12;
			
			_playingIcon = new (UIResource.CurrentPlay)();
			_playingIcon.visible = false;
			addChild(_playingIcon);
			cb = new CheckBox();
			cb.label = "";
			_title = new TextField();
			_title.selectable = false;
			_title.mouseEnabled = false;
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.defaultTextFormat = textFormat;
			_title.text = "";
			addChild(cb);
			addChild(_title);
			
			_author = new TextField();
			_author.selectable = false;
			_author.mouseEnabled = false;
			_author.autoSize = TextFieldAutoSize.LEFT;
			_author.defaultTextFormat = textFormat;
			_author.text = "";
			addChild(_author);
			
		}
		private function addListener():void{
			
			addEventListener(MouseEvent.MOUSE_OVER, showBackground);
			addEventListener(MouseEvent.MOUSE_OUT, hideBackground);
			background.addEventListener(MouseEvent.DOUBLE_CLICK, playMusic);
			
		}
		private function playMusic(event:MouseEvent):void{
			
			this.dispatchEvent(event);
			
		}
		private function showBackground(event:MouseEvent):void{
			
			background.alpha = 1;
			
		}
		private function hideBackground(event:MouseEvent):void{
			
			background.alpha = 0;
			
		}
		public function set title(str:String):void{
			
			_title.text = str;
			
		}
		public function get title():String{
			
			return _title.text;
			
		}
		public function set author(str:String):void{
			
			_author.text = str;
			
		}
		public function get author():String{
			
			return _author.text;
			
		}
		public function set id(num:Number):void{
			
			_id = num;
			
		}
		public function get id():Number{
			
			return _id;
			
		}
		public function set url(str:String):void{
			
			_url = str;
			
		}
		public function get url():String{
			
			return _url;
			
		}
		public function set selected(bool:Boolean):void{
			
			cb.selected = bool;
			
		}
		public function get selected():Boolean{
			
			return cb.selected;
			
		}
		
		public function set isPlaying(bool:Boolean):void{
			
			_playingIcon.visible = bool;
			
		}
		
		public function get isPlaying():Boolean{
			
			return _playingIcon.visible;
			
		}
		
		public function layout(w:uint, h:uint):void{
			
			_playingIcon.x = 5;
			_playingIcon.y = (cb.height - 9) / 2 + 3;
			cb.width = 30;
			cb.x = _playingIcon.x + 10;
			cb.y = (h - cb.height) / 2;
			_author.x = w - _author.textWidth - 40;
			_author.y = (h - _author.textHeight) / 2;
			_title.x = cb.x + cb.width + 10;
			_title.y = (h - _title.textHeight) / 2;
			
		}
	}
}