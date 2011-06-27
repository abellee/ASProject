package com.iabel.ui
{
	import fl.controls.Button;
	import fl.controls.ColorPicker;
	import fl.controls.DataGrid;
	import fl.controls.List;
	import fl.controls.TextArea;
	import fl.controls.UIScrollBar;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class RealLifePlayerList extends Sprite
	{
		private var topBar:Sprite;
		private var btmBar:Sprite;
		private var songTitle:TextField;
		private var curPlaying:ListItem;
		private var playList:Vector.<ListItem>;
		private var dg:DataGrid;
		private var ci:int = -1;
		private var delBtn:Button;
		private var allSelect:Button;
		private var deSelect:Button;
		private var pcr:PlayingIconRenderer;
		public function RealLifePlayerList()
		{
			super();
			init();
			addListener();
			draw();
		}
		private function addListener():void{
			
			delBtn.addEventListener(MouseEvent.CLICK, deleteLocalData);
			deSelect.addEventListener(MouseEvent.CLICK, deSelectAll);
			allSelect.addEventListener(MouseEvent.CLICK, allSelectHandler);
			dg.addEventListener(Event.RENDER, checkIsPlaying);
			
		}
		private function checkIsPlaying(event:Event):void{
			
			setIsPlaying(0, 0);
			
		}
		public function setPreplaying(index:uint):void{
			
			var item:Object = dg.getItemAt(index);
			
		}
		private function deSelectAll(event:MouseEvent):void{
			
			var arr:Array = dg.dataProvider.toArray();
			for each(var obj:Object in arr){
				
				obj.selected = false;
				
			}
			dg.dataProvider = dg.dataProvider;
			
		}
		private function allSelectHandler(event:MouseEvent):void{
			
			var arr:Array = dg.dataProvider.toArray();
			for each(var obj:Object in arr){
				
				obj.selected = true;
				
			}
			dg.dataProvider = dg.dataProvider;
			
		}
		private function deleteLocalData(event:MouseEvent):void{
			
			var arr:Array = dg.dataProvider.toArray();
			if(!arr || !arr.length){
				
				return;
				
			}
			for each(var obj:Object in arr){
				
				if(obj.selected){
					
					dg.removeItem(obj);
					
				}
				
			}
			setLocalData(dg.dataProvider.toArray());
			
		}
		private function init():void{
			
			topBar = new Sprite();
			topBar.graphics.lineStyle(1, 0x000000, .4);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(730, 30, Math.PI / 2);
			topBar.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xf5f5f5], [1, 1], [100, 255], matrix);
			topBar.graphics.drawRoundRect(0, 0, 730, 30, 5, 5);
			topBar.graphics.endFill();
			
			addChild(topBar);
			
			btmBar = new Sprite();
			btmBar.graphics.beginFill(0xf3f3f3, 1);
			btmBar.graphics.drawRoundRect(0, 0, 729, 30, 5, 5);
			btmBar.graphics.endFill();
			
			addChild(btmBar);
			btmBar.x = 1;
			btmBar.y = 370;
			
			delBtn = new Button();
			delBtn.label = "删除";
			delBtn.width = 60;
			addChild(delBtn);
			delBtn.x = 135;
			delBtn.y = 374;
			
			allSelect = new Button();
			allSelect.label = "全选";
			allSelect.width = 60;
			addChild(allSelect);
			allSelect.x = 5;
			allSelect.y = 374;
			
			deSelect = new Button();
			deSelect.label = "反选";
			deSelect.width = 60;
			addChild(deSelect);
			deSelect.x = 70;
			deSelect.y = 374;
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.color = 0x000000;
			titleFormat.size = 12;
			titleFormat.bold = true;
			
			songTitle = new TextField();
			songTitle.selectable = false;
			songTitle.defaultTextFormat = titleFormat;
			songTitle.autoSize = TextFieldAutoSize.LEFT;
			songTitle.text = "歌曲列表";
			
			addChild(songTitle);
			songTitle.x = 5;
			songTitle.y = 8;
			
			var pic:DataGridColumn = new DataGridColumn();
			pic.cellRenderer = PlayingIconRenderer;
			pic.width = 20;
			var dgc:DataGridColumn = new DataGridColumn();
			dgc.cellRenderer = CheckRenderer;
			dgc.width = 40;
			var songName:DataGridColumn = new DataGridColumn();
			songName.dataField = "name";
			songName.width = 400;
			songName.cellRenderer = DataGridCellRenderer;
			var authorName:DataGridColumn = new DataGridColumn();
			authorName.cellRenderer = DataGridCellRenderer;
			authorName.dataField = "artist";
			authorName.width = 100;
			dg = new DataGrid();
			dg.rowHeight = 30;
			dg.addColumn(pic);
			dg.addColumn(dgc);
			dg.addColumn(songName);
			dg.addColumn(authorName);
			dg.setSize(530, 340);
			dg.showHeaders = false;
			addChild(dg);
			dg.y = 30;
			setList();
			
		}
		public function setIsPlaying(col:uint, row:uint):void{
			
			if(pcr){
				
				pcr.isPlaying = false;
				
			}
			var cr:PlayingIconRenderer = dg.getCellRendererAt(ci, 0) as PlayingIconRenderer;
			if(cr){
				
				cr.isPlaying = true;
				pcr = cr;
				
			}
			
		}
		public function setList():void{
			
			var obj:Array = readLocalData();
			if(!obj){
				
				return;
				
			}
			var dp:DataProvider = new DataProvider(obj);
			dg.dataProvider = dp;
			
		}
		public function addSong(arr:Array):void{
			
			var playItem:Object;
			var so:SharedObject = SharedObject.getLocal("RealLifeMusicList");
			var oarr:Array;
			if(so.data.list && so.data.list.length){
				
				oarr = so.data.list;
				so.data.list = so.data.list.concat(arr);
				so.flush();
				so.close();
				ci = oarr.length;
				
			}else{
				
				so.data.list = arr;
				so.flush();
				so.close();
				ci = 0;
				
			}
			setList();
			playItem = dg.getItemAt(ci);
			Main.instance.playMusic(playItem.url, playItem.id, playItem.name);
			
		}
		private function readLocalData():Array{
			
			var so:SharedObject = SharedObject.getLocal("RealLifeMusicList");
			if(so.data && so.data.list){
				
				for each(var obj:Object in so.data.list){
					
					obj.selected = false;
					obj.isPlaying = false;
					
				}
				return so.data.list;
				
			}
			return null;
			
		}
		private function setLocalData(arr:Array):void{
			
			var so:SharedObject = SharedObject.getLocal("RealLifeMusicList");
			so.data.list = arr;
			so.flush();
			so.close();
			
		}
		public function clearLocalData():void{
			
			var so:SharedObject = SharedObject.getLocal("RealLifeMusicList");
			so.clear();
			so.close();
			
		}
		public function get currentPlaying():ListItem{
			
			return curPlaying;
			
		}
		public function playSongByMode(mode:String):void{
			
			switch(mode){
				
				case "single":
					
					break;
				case "all":
					if(ci >= (dg.dataProvider.length - 1)){
						
						ci = 0;
						break;
						
					}
					ci++;
					break;
				case "random":
					ci = uint(Math.random() * dg.dataProvider.length);
					break;
				
			}
			var item:Object = dg.getItemAt(ci);
			Main.instance.playMusic(item.url, item.id, item.name);
			this.setIsPlaying(0, ci);
			
		}
		public function preSong():void{
			
			if(ci == -1){
				
				return;
				
			}
			if(ci <= 0){
				
				ci = 0;
				
			}else{
				
				ci --;
				
			}
			var item:Object = dg.getItemAt(ci);
			Main.instance.playMusic(item.url, item.id, item.name);
			this.setIsPlaying(0, ci);
			
		}
		public function set curIndex(value:int):void{
			
			ci = value;
			
		}
		public function get curIndex():int{
			
			return ci;
			
		}
		public function nextSong():void{
			
			if(ci >= (dg.dataProvider.length - 1)){
				
				ci = 0;
				
			}else{
				
				ci ++;
				
			}
			var item:Object = dg.getItemAt(ci);
			Main.instance.playMusic(item.url, item.id, item.name);
			this.setIsPlaying(0, ci);
			
		}
		private function draw():void{
			
			graphics.lineStyle(1, 0x000000, .4);
			graphics.beginFill(0xffffff, 1);
			graphics.drawRoundRect(0, 0, 730, 400, 5, 5);
			graphics.endFill();
			
		}
	}
}