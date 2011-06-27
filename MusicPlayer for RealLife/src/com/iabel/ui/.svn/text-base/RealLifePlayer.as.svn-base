package com.iabel.ui
{
	import com.iabel.factory.ButtonFactory;
	
	import fl.controls.Button;
	import fl.controls.Slider;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import resource.UIResource;
	
	public class RealLifePlayer extends Sprite
	{
		private var playButton:AButton;
		private var pauseButton:AButton;
		private var preButton:AButton;
		private var nextButton:AButton;
		private var linkButton:AButton;
		private var singleRepeatButton:AButton;
		private var allRepeatButton:AButton;
		private var randomRepeatButton:AButton;
		private var downloadBackground:AButton;
		private var loadingBar:AButton;
		private var playingBar:AButton;
		
		private var sc:Slider;
		
		private var titleText:TextField;
		private var timeText:TextField;
		
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var stf:SoundTransform;
		
		private var soundPos:Number = 0;
		
		private var totalTime:Date;
		
		private var curURL:String;
		
		private var curState:String = "play";
		
		private var playMode:String = "all";
		private var preModeBtn:AButton;
		
		private var csn:String = "";
		
		public function RealLifePlayer()
		{
			super();
			init();
			draw();
			addListener();
		}
		private function init():void{
			
			playButton = ButtonFactory.PlayButton();
			playButton.label = "";
			
			pauseButton = ButtonFactory.PauseButton();
			pauseButton.label = "";
			
			preButton = ButtonFactory.PreviouseButton();
			preButton.label = "";
			
			nextButton = ButtonFactory.NextButton();
			nextButton.label = "";
			
			linkButton = ButtonFactory.LinkButton();
			linkButton.label = "";
			
			singleRepeatButton = ButtonFactory.SinglePlayButton();
			singleRepeatButton.label = "";
			singleRepeatButton.toolTip = "单曲播放";
			
			allRepeatButton = ButtonFactory.AllRepeatButton();
			allRepeatButton.label = "";
			allRepeatButton.toolTip = "循环播放";
			
			randomRepeatButton = ButtonFactory.RandomPlayButton();
			randomRepeatButton.label = "";
			randomRepeatButton.toolTip = "随机播放";
			
			downloadBackground = ButtonFactory.DownloadBackground();
			
			loadingBar = ButtonFactory.LoadingBar();
			loadingBar.mouseEnabled = false;
			loadingBar.mouseChildren = false;
			
			playingBar = ButtonFactory.PlayingBar();
			playingBar.mouseEnabled = false;
			playingBar.mouseChildren = false;
			
			linkButton = ButtonFactory.LinkButton();
			
			sc = ButtonFactory.SoundController();
			
			preButton.x = 20;
			preButton.y = 25;
			
			playButton.x = 50;
			playButton.y = 18;
			
			pauseButton.x = 50;
			pauseButton.y = 18;
			pauseButton.visible = false;
			
			nextButton.x = 95;
			nextButton.y = 25;
			
			downloadBackground.x = 135;
			downloadBackground.y = 39;
			
			loadingBar.x = 135;
			loadingBar.y = 40;
			
			playingBar.x = 135;
			playingBar.y = 40;
			
			linkButton.x = 137;
			linkButton.y = 52;
			
			stf = new SoundTransform();
			stf.volume = .5;
			
			sc.x = 33;
			sc.y = 67;
			
			addChild(playButton);
			addChild(preButton);
			addChild(nextButton);
			addChild(downloadBackground);
			addChild(loadingBar);
			addChild(playingBar);
			//addChild(linkButton);
			addChild(pauseButton);
			addChild(sc);
			addChild(singleRepeatButton);
			addChild(allRepeatButton);
			addChild(randomRepeatButton);
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.size = 15;
			titleFormat.bold = true;
			
			titleText = new TextField();
			titleText.defaultTextFormat = titleFormat;
			titleText.autoSize = TextFieldAutoSize.LEFT;
			titleText.text = "";
			
			addChild(titleText);
			
			titleText.x = 135;
			titleText.y = 18;
			var timeTextFormat:TextFormat = new TextFormat();
			timeTextFormat.size = 12;
			
			timeText = new TextField();
			timeText.defaultTextFormat = timeTextFormat;
			timeText.autoSize = TextFieldAutoSize.LEFT;
			timeText.text = "00:00 / 00:00";
			
			addChild(timeText);
			
			timeText.x = 613;
			timeText.y = 36;
			
			allRepeatButton.x = 603;
			allRepeatButton.y = 56;
			
			singleRepeatButton.x = 633;
			singleRepeatButton.y = 56;
			
			randomRepeatButton.x = 663;
			randomRepeatButton.y = 56;
			
			loadingBar.width = 0;
			playingBar.width = 0;
			
		}
		private function addListener():void{
			
			pauseButton.addEventListener(MouseEvent.CLICK, soundPause_handler);
			playButton.addEventListener(MouseEvent.CLICK, playSound);
			downloadBackground.addEventListener(MouseEvent.CLICK, playSpecifyPos);
			sc.addEventListener(Event.CHANGE, changeSoundTransform);
			
			singleRepeatButton.addEventListener(MouseEvent.CLICK, changeSingleRepeatMode);
			allRepeatButton.addEventListener(MouseEvent.CLICK, changeAllRepeatMode);
			randomRepeatButton.addEventListener(MouseEvent.CLICK, changeRandomRepeatMode);
			
			preButton.addEventListener(MouseEvent.CLICK, playPreSong);
			nextButton.addEventListener(MouseEvent.CLICK, playNextSong);
			
		}
		private function playPreSong(event:MouseEvent):void{
			
			Main.instance.preSong();
			
		}
		private function playNextSong(event:MouseEvent):void{
			
			Main.instance.nextSong();
			
		}
		private function changeSingleRepeatMode(event:MouseEvent):void{
			
			if(preModeBtn){
				
				preModeBtn.toggle = false;
				preModeBtn.toggle = true;
				if(preModeBtn == singleRepeatButton){
					
					playMode = "all";
					return;
					
				}
				
			}
			playMode = "single";
			preModeBtn = singleRepeatButton;
			
		}
		private function changeAllRepeatMode(event:MouseEvent):void{
			
			if(preModeBtn){
				
				preModeBtn.toggle = false;
				preModeBtn.toggle = true;
				if(preModeBtn == allRepeatButton){
					
					playMode = "all";
					return;
					
				}
				
			}
			playMode = "all";
			preModeBtn = allRepeatButton;
			
		}
		private function changeRandomRepeatMode(event:MouseEvent):void{
			
			if(preModeBtn){
				
				preModeBtn.toggle = false;
				preModeBtn.toggle = true;
				if(preModeBtn == randomRepeatButton){
					
					playMode = "random";
					return;
					
				}
				
			}
			playMode = "random";
			preModeBtn = randomRepeatButton;
			
		}
		private function changeSoundTransform(event:Event):void{
			
			stf.volume = sc.value / 10;
			if(soundChannel){
				
				soundChannel.soundTransform = stf;
				
			}
			
		}
		public function setTitle(str:String):void{
			
			titleText.text = str;
			
		}
		private function playSpecifyPos(event:MouseEvent):void{
			
			var mousePosX:uint = downloadBackground.mouseX;
			var percent:Number = mousePosX / 458;
			if(totalTime){
				
				var pos:uint = totalTime.time * percent;
				soundChannel.stop();
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete_handler);
				soundChannel = sound.play(pos);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete_handler);
				Main.instance.showLyrics(pos);
				playButton.visible = false;
				pauseButton.visible = true;
				
			}
			
		}
		private function soundPause_handler(event:MouseEvent):void{
			
			soundPos = soundChannel.position;
			soundChannel.stop();
			playButton.visible = true;
			pauseButton.visible = false;
			
		}
		private function playSound(event:MouseEvent):void{
			
			if(curState == "complete"){
				
				play(curURL, csn);
				return;
				
			}
			sc.value = this.stf.volume * 10;
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete_handler);
			soundChannel = sound.play(soundPos, 0, this.stf);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete_handler);
			playButton.visible = false;
			pauseButton.visible = true;
			
		}
		private function playSoundByMode():void{
			
			Main.instance.playSongByMode(playMode);
			
		}
		public function play(str:String, name:String):void{
			
			curState = "play";
			csn = name;
			Main.instance.setPlayingIcon(0, 0);
			this.setTitle(csn);
			playButton.visible = false;
			pauseButton.visible = true;
			curURL = str;
			loadingBar.width = 0;
			playingBar.width = 0;
			if(sound){
				
				removeEventListener(Event.ENTER_FRAME, showCurrentTime);
				sound.removeEventListener(Event.COMPLETE, soundLoad_completeHandler);
				soundChannel.stop();
				sound = null;
				
			}
			sound = new Sound(new URLRequest(str));
			sound.addEventListener(Event.COMPLETE, soundLoad_completeHandler);
			addEventListener(Event.ENTER_FRAME, showCurrentTime);
			sc.value = this.stf.volume * 10;
			soundChannel = sound.play(0, 0, stf);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete_handler);
			
		}
		private function soundComplete_handler(event:Event):void{
			
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete_handler);
			curState = "complete";
			playButton.visible = true;
			pauseButton.visible = false;
			removeEventListener(Event.ENTER_FRAME, showCurrentTime);
			sound.removeEventListener(Event.COMPLETE, soundLoad_completeHandler);
			soundChannel.stop();
			sound = null;
			Main.instance.playSongByMode(playMode);
			
		}
		private function showCurrentTime(event:Event):void{
			
			Main.instance.showLyrics(soundChannel.position);
			var percent:Number = sound.bytesLoaded / sound.bytesTotal;
			totalTime = new Date(sound.length / percent);
			loadingBar.width = percent * 458;
			playingBar.width = soundChannel.position / totalTime.time * 458;
			var nowTime:Date = new Date(soundChannel.position);
			var nowStr:String = (nowTime.getMinutes() < 10 ? ("0" + nowTime.getMinutes()) : ("" + nowTime.getMinutes())) + ":" + (nowTime.getSeconds() < 10 ? ("0" + nowTime.getSeconds()) : ("" + nowTime.getSeconds()));
			if(totalTime && soundChannel){
				var totalStr:String = (totalTime.getMinutes() < 10 ? ("0" + totalTime.getMinutes()) : ("" + totalTime.getMinutes())) + ":" + (totalTime.getSeconds() < 10 ? ("0" + totalTime.getSeconds()) : ("" + totalTime.getSeconds()));
				if(totalStr != "NaN:NaN"){
					
					timeText.text = nowStr + " / " + totalStr;
					
				}
				
			}
			
		}
		private function soundLoad_completeHandler(event:Event):void{
			
			sound.removeEventListener(Event.COMPLETE, soundLoad_completeHandler);
			
		}
		private function draw():void{
			
			graphics.lineStyle(1, 0x000000, .4);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(730, 80, Math.PI / 2);
			graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xf5f5f5], [1, 1], [100, 255], matrix);
			graphics.drawRoundRect(0, 0, 730, 80, 5, 5);
			graphics.endFill();
			
		}
	}
}