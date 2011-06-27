package com.iabel.ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class RealLifeLyrics extends Sprite
	{
		private var lyricsText:TextField;
		private var lyricsDownload:TextField;
		private var urlLoader:URLLoader;
		private var lycriArray:Array;
		private var highlightFormat:TextFormat;
		private var defaultTextFormat:TextFormat;
		private var preText:TextField;
		private var lyricsContainer:Sprite;
		public function RealLifeLyrics()
		{
			super();
			init();
			draw();
		}
		private function init():void{
			
			defaultTextFormat = new TextFormat();
			defaultTextFormat.color = 0xcccccc;
			defaultTextFormat.align = "center";
			defaultTextFormat.size = 12;
			defaultTextFormat.leading = 14;
			defaultTextFormat.bold = false;
			
			highlightFormat = new TextFormat();
			highlightFormat.color = 0x000000;
			highlightFormat.align = "center";
			highlightFormat.size = 12;
			highlightFormat.leading = 14;
			highlightFormat.bold = true;
			
			/*lyricsText = new TextField();
			lyricsText.selectable = false;
			lyricsText.mouseEnabled = false;
			lyricsText.mouseWheelEnabled = false;
			lyricsText.defaultTextFormat = defaultTextFormat;
			lyricsText.multiline = true;
			lyricsText.wordWrap = true;
			lyricsText.width = 190;
			lyricsText.text = "";
			lyricsText.height = lyricsText.textHeight;
			addChild(lyricsText);
			lyricsText.x = 5;
			lyricsText.y = 200;*/
			
			lyricsContainer = new Sprite();
			lyricsContainer.mouseEnabled = false;
			lyricsContainer.mouseChildren = false;
			lyricsContainer.x = 5;
			lyricsContainer.y = 200;
			addChild(lyricsContainer);
			
			addMask();
			
			var downloadTextFormat:TextFormat = new TextFormat();
			downloadTextFormat.size = 12;
			downloadTextFormat.align = "center";
			downloadTextFormat.color = 0x0000ff;
			downloadTextFormat.underline = true;
			downloadTextFormat.bold = true;
			
			lyricsDownload = new TextField();
			lyricsDownload.width = 200;
			lyricsDownload.defaultTextFormat = downloadTextFormat;
			lyricsDownload.text = "歌词下载";
			//addChild(lyricsDownload);
			
			lyricsDownload.x = 0;
			lyricsDownload.y = 375;
			
		}
		public function decodeLycris(url:String):void{
			
			if(urlLoader){
				
				urlLoader.removeEventListener(Event.COMPLETE, lycriLoad_completeHandler);
				urlLoader = null;
				
			}
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, lycriLoad_completeHandler);
			urlLoader.load(new URLRequest(url));
			
		}
		private function lycriLoad_completeHandler(event:Event):void{
			
			urlLoader.removeEventListener(Event.COMPLETE, lycriLoad_completeHandler);
			var str:String = event.target.data;
			/*var emptyPattern:RegExp = /\s/g;
			str = str.replace(emptyPattern, "");
			trace(str);
			trace("---------------------------------------------");*/
			urlLoader = null;
			
			//patterns
			var pattern:RegExp = /\[\d\d:\d\d\.\d\d\].*/g;
			var repPattern:RegExp = /(\[\d\d:\d\d\.\d\d\])+/g;
			var timePattern:RegExp = /\[\d\d:\d\d\.\d\d\]/g;
			var secondPattern:RegExp = /\[(\d\d):(\d\d\.\d\d)\]/;
			
			/*
			[ti:爱的供养]
			[ar:杨蜜]
			[al:]
			[by:bzmtv.com]
			*/
			var result1:Array = str.match(pattern);
			lycriArray = [];
			for each(var nstr:String in result1){
				
				var lstr:String = nstr.replace(repPattern, "");
				var timeStr:Array = nstr.match(timePattern);
				
				for each(var tstr:String in timeStr){
					
					var tempObj:Object = {};
					var min:String = tstr.replace(secondPattern, "$1");
					var sec:String = tstr.replace(secondPattern, "$2");
					tempObj.pos = Number(min) * 60 + Number(sec);
					tempObj.text = lstr;
					lycriArray.push(tempObj);
					
				}
				
			}
			lycriArray.sortOn("pos", Array.NUMERIC);
			
			var realLycris:String = "";
			
			while(lyricsContainer.numChildren){
				
				lyricsContainer.removeChildAt(0);
				
			}
			var len:uint = lycriArray.length;
			for (var i:uint = 0; i < len; i++){
				
				//realLycris += obj.text + "\n";
				var obj:Object = lycriArray[i];
				var txt:TextField = new TextField();
				txt.defaultTextFormat = this.defaultTextFormat;
				txt.selectable = false;
				txt.mouseEnabled = false;
				txt.wordWrap = true;
				txt.mouseWheelEnabled = false;
				txt.autoSize = TextFieldAutoSize.CENTER;
				txt.text = obj.text;
				txt.width = 195;
				txt.x = 2;
				if(!i){
					
					txt.y = lyricsContainer.numChildren * (txt.textHeight + 5);
					
				}else{
					
					var preObj:Object = lycriArray[i - 1];
					txt.y = preObj.box.y + preObj.box.textHeight + 5;
					
				}
				lyricsContainer.addChild(txt);
				lyricsContainer.dispatchEvent(new Event(Event.RENDER));
				obj.box = txt;
				obj.ypos = txt.y;
				
			}
//			lycris = realLycris;
			
		}
		public function set lycris(str:String):void{
			
			lyricsText.text = str;
			lyricsText.y = 200;
			lyricsText.height = lyricsText.textHeight;
			
		}
		public function get lycris():String{
			
			return lyricsText.text;
			
		}
		public function showCurrentLine(curPos:Number):void{
			
			var curStr:Object = getCurLineText(curPos / 1000);
			if(curStr == null){
				
				return;
				
			}
			if(preText){
				
				preText.setTextFormat(this.defaultTextFormat);
				preText = null;
				
			}
			preText = curStr.box;
			preText.setTextFormat(this.highlightFormat);
			/*var index:uint = lyricsText.getLineOffset(curStr.line);
			var rect:Rectangle = lyricsText.getCharBoundaries(index);
			if(prePos){
				
				lyricsText.setTextFormat(this.defaultTextFormat, prePos.x, prePos.y);
				prePos = null;
				
			}
			prePos = new Point(index, index + curStr.text.length);
			trace(index, prePos, ">>>>>>>>" + curStr.text, rect);
			if(index > lyricsText.text.length || (index + curStr.text.length) > lyricsText.text.length){
				
				return;
				
			}
			lyricsText.setTextFormat(this.highlightFormat, prePos.x, prePos.y);*/
			var ty:uint = curStr.ypos;
			TweenLite.to(lyricsContainer, .5, {y: 200 - ty});
			
		}
		private function getCurLineText(curPos:Number):Object{
			
			if(!lycriArray || !lycriArray.length){
				
				return null;
				
			}
			var len:uint = lycriArray.length;
			for (var i:uint = 0; i < len; i++){
				
				var obj:Object = lycriArray[i];
				if(obj){
					
					if(obj.pos == curPos || (curPos > obj.pos && curPos < Number(lycriArray[i + 1] != null ? lycriArray[i + 1].pos : false))){
						
						var emptyPat:RegExp = /\s/g;
						var str:String = String(obj.text).replace(emptyPat, "");
						if(obj.text == ""){
							
							return null;
							
						}else{
							
							return obj;
							
						}
						
					}
					
				}
				
			}
			return null;
			
		}
		private function addMask():void{
			
			var sp:Sprite = new Sprite();
			sp.mouseEnabled = false;
			sp.mouseChildren = false;
			sp.graphics.beginFill(0x000000, 0);
			sp.graphics.drawRect(0, 0, 200, 390);
			sp.graphics.endFill();
			addChild(sp);
			lyricsContainer.mask = sp;
			
		}
		private function draw():void{
			
			var border:Sprite = new Sprite();
			border.graphics.lineStyle(1, 0x000000, .4);
			border.graphics.lineTo(0, 399);
			addChild(border);
			this.graphics.beginFill(0xffffff, 1);
			this.graphics.drawRoundRectComplex(0, 0, 200, 399, 0, 5, 0, 5);
			this.graphics.endFill();
			
		}
	}
}