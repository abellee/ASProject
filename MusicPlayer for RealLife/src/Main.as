package
{
	import com.iabel.ui.RealLifeLyrics;
	import com.iabel.ui.RealLifePlayer;
	import com.iabel.ui.RealLifePlayerList;
	import com.iabel.ui.Tooltip;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import org.osmf.utils.URL;
	
	[SWF(frameRate=30, width=732, height=492)]
	public class Main extends Sprite
	{
		public static var instance:Main;
		private var player:RealLifePlayer;
		private var playList:RealLifePlayerList;
		private var lyrics:RealLifeLyrics;
		private var urlLoader:URLLoader;
		private var basicURL:String = "http://www.hongrg.com";
		private var lyricsURL:String = "/Test/ReturnLyricsById.aspx";
		private var songURL:String = "/Test/ReturnSongXML.aspx";
		public function Main()
		{
			instance = this;
			init();	
		}
		private function init():void{
			
			var param:Object = this.stage.loaderInfo.parameters;
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// for testing
			/*urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadSongInfo_completeHandler);
			urlLoader.load(new URLRequest(basicURL + songURL + "?id=5,29")); */
			
			if(param.id && param.basicURL && param.songURL && param.lyricsURL){
				
				basicURL = param.basicURL;
				lyricsURL = param.lyricsURL;
				songURL = param.songURL;
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, loadSongInfo_completeHandler);
				urlLoader.load(new URLRequest(basicURL + songURL + "?id=" + param.id));
				
			}
			player = new RealLifePlayer();
			addChild(player);
			
			playList = new RealLifePlayerList();
			addChild(playList);
			playList.y = 90;
			
			lyrics = new RealLifeLyrics();
			addChild(lyrics);
			lyrics.x = 530;
			lyrics.y = 91;
			
		}
		private function loadSongInfo_completeHandler(event:Event):void{
			
			urlLoader.removeEventListener(Event.COMPLETE, loadSongInfo_completeHandler);
			var data:XML = XML(event.target.data);
			urlLoader = null;
			
			var arr:Array;
			if(data.children().length()){
				
				arr = [];
				for each(var xml:XML in data.children()){
					
					var obj:Object = {};
					obj.id = Number(xml.id);
					obj.name = String(xml.name);
					obj.artist = String(xml.artist);
					obj.url = String(xml.url);
					obj.selected = false;
					arr.push(obj);
					
				}
				
			}
			playList.addSong(arr);
			playList.setList();
			
		}
		public function playSongByMode(mode:String):void{
			
			playList.playSongByMode(mode);
			
		}
		public function nextSong():void{
			
			playList.nextSong();
			
		}
		public function setPlayingIcon(col:uint, row:uint):void{
			
			playList.setIsPlaying(0, row);
			
		}
		public function set curIndex(value:int):void{
			
			playList.curIndex = value;
			
		}
		public function preSong():void{
			
			playList.preSong();
			
		}
		public function showLyrics(curPos:Number):void{
			
			lyrics.showCurrentLine(curPos);
			
		}
		public function playMusic(url:String, id:Number, name:String):void{
			
			lyrics.decodeLycris(basicURL + lyricsURL + "?id=" + id);
			player.play(url, name);
			
		}
		public function addToolTip(tt:Tooltip):void{
			
			addChild(tt);
			tt.x = mouseX + 10;
			tt.y = mouseY + 10;
			if((tt.x + tt.width) > 730 || (tt.y + tt.height) > 491){
				
				tt.x = mouseX - tt.width - 10;
				tt.y = mouseY - tt.height - 10;
				
			}
			
		}
		public function removeToolTip(tt:Tooltip):void{
			
			if(tt && this.contains(tt)){
				
				this.removeChild(tt);
				
			}
			
		}
	}
}