package system {
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import mew.data.TimingWeiboVariable;
	import mew.modules.ITiming;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;

	public class TimingWeiboManager
	{
		private var timer:Timer = null;
		private var filePath:String = "tmb.db";
		private var conn:SQLConnection = null;
		private var dbStatement:SQLStatement = new SQLStatement();
		private var timingWeiboList:Vector.<TimingWeiboVariable> = null;
		private var isSelfReading:Boolean = true;
		private var file:File = null;
		
		public var target:ITiming = null;
		
		public function TimingWeiboManager()
		{
		}
		public function check():void
		{
			var file:File = File.applicationDirectory.resolvePath(filePath);
			if(!file.exists){
				trace("create table");
				createTable(file);
				return;
			}
			trace("table exists!");
			MewSystem.database = true;
			var now:Number = new Date().time;
			readData(now);
		}
		public function checkData(num:Number):Boolean
		{
			if(timingWeiboList && timingWeiboList.length){
				for each(var tmv:TimingWeiboVariable in timingWeiboList){
					if(tmv.time == num) return false;
				}
			}
			return true;
		}
		private function startTiming():void
		{
			if(timer && timer.running){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timingWeibo_sendHandler);
				timer = null;
			}
			if(!timingWeiboList.length) return;
			var firstItem:TimingWeiboVariable = timingWeiboList[0];
			trace("______________________________");
			firstItem.toString()
			trace("______________________________");
			var now:Date = new Date();
			var nowTime:Number = now.time;
			if(nowTime <= firstItem.time) start(firstItem.time - nowTime);
		}
		private function sortByTime(a:TimingWeiboVariable, b:TimingWeiboVariable):Number
		{
			return a.time - b.time;
		}
		public function start(time:int):void
		{
			timer = new Timer(time);
			timer.addEventListener(TimerEvent.TIMER, timingWeibo_sendHandler);
			timer.start();
		}
		private function timingWeibo_sendHandler(event:TimerEvent):void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, timingWeibo_sendHandler);
			timer = null;
			var firstItem:TimingWeiboVariable = timingWeiboList[0];
			if(firstItem.img == "null"){
				sendTextContent();
				return;
			}
			if(!file) file = File.applicationStorageDirectory.resolvePath("timing/" + firstItem.img);
			file.addEventListener(IOErrorEvent.IO_ERROR, noImageFile);
			file.addEventListener(Event.COMPLETE, fileLoadComplete);
			file.load();
		}
		// 0 未发送 1 发送成功 2 发送失败 3 图片丢失 但已发送文字
		private function noImageFile(event : IOErrorEvent) : void
		{
			file.removeEventListener(IOErrorEvent.IO_ERROR, noImageFile);
			file.removeEventListener(Event.COMPLETE, fileLoadComplete);
			file = null;
			trace("can't load image");
			sendTextContent();
		}
		
		private function sendTextContent(imageLoose:Boolean = false):void
		{
			var firstItem:TimingWeiboVariable = timingWeiboList[0];
			trace("send no image");
			MewSystem.app.alternationCenter.updateStatus(firstItem.content);
			if(imageLoose) firstItem.state = 3;
			else firstItem.state = 1;
			updateData(firstItem.id, firstItem);
			timingWeiboList.shift();
			startTiming();
		}
		private function fileLoadComplete(event:Event):void
		{
			file.removeEventListener(IOErrorEvent.IO_ERROR, noImageFile);
			file.removeEventListener(Event.COMPLETE, fileLoadComplete);
			var firstItem:TimingWeiboVariable = timingWeiboList[0];
			trace("send with image");
			MewSystem.app.alternationCenter.updateStatus(firstItem.content, file.data);
			file = null;
			firstItem.state = 1;
			updateData(firstItem.id, firstItem);
			timingWeiboList.shift();
			startTiming();
		}
		
		private function createTable(file:File):void
		{
			trace("create");
			if(!conn) conn = new SQLConnection();
			conn.open(file);
			if(!dbStatement) dbStatement = new SQLStatement();
			dbStatement.text = "create table if not exists mew_timing(" +
				"id integer not null primary key autoincrement, " +
				"content text not null, " +
				"img text, " +
				"time integer not null, " + 
				"state smallint not null default 0, " +
				"createTime integer not null)";
			dbStatement.sqlConnection = conn;
			dbStatement.addEventListener(SQLEvent.RESULT, createDBComplete);
			dbStatement.execute();
		}

		private function createDBComplete(event : SQLEvent) : void
		{
			var result:SQLResult = dbStatement.getResult();
			if(result) MewSystem.database = true;
			else MewSystem.database = false;
			closeDB();
		}
		
		private function closeDB():void
		{
			conn.close();
			conn = null;
			dbStatement = null;
			target = null;
		}
		
		private function openConnection():void
		{
			var file:File = File.applicationDirectory.resolvePath(filePath);
			if(!MewSystem.database || !file.exists){
				if(target) target.showLightAlert("定时微博数据库出错, 请重新启动软件!");
				return;
			}
			if(!conn) conn = new SQLConnection();
			if(!dbStatement) dbStatement = new SQLStatement();
			dbStatement.sqlConnection = conn;
			conn.open(file);
		}

		private function writeDataComplete(event : SQLEvent) : void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, writeDataComplete);
			var result:SQLResult = dbStatement.getResult();
			if(target){
				if(result) target.showLightAlert("添加成功!");
				else target.showLightAlert("添加失败!");
			}
			closeDB();
			var num:Number = new Date().time;
			readData(num, true);
		}
		
		public function writeData(data:TimingWeiboVariable):void
		{
			openConnection();
			dbStatement.text = "insert into mew_timing(content, img, time, state, createTime) values('" + data.content + "', '" + data.img + "', '"
			 + data.time + "', '" + data.state + "', '" + data.createTime + "')";
			 trace("write: " + dbStatement.text);
			dbStatement.addEventListener(SQLEvent.RESULT, writeDataComplete);
			dbStatement.execute();
		}

		public function readData(num:Number = 0, isSelf:Boolean = true):void
		{
			isSelfReading = isSelf;
			openConnection();
			dbStatement.text = "select * from mew_timing where time >= " + num + " order by id desc";
			dbStatement.addEventListener(SQLEvent.RESULT, dataReadComplete);
			dbStatement.execute();
		}
		
		public function updateData(num:Number, newData:TimingWeiboVariable):void
		{
			openConnection();
			dbStatement.text = "update mew_timing set content='" + newData.content + "', img='" + newData.img + "', time='"
			 + newData.time + "', state='" + newData.state + "', createTime='" + newData.createTime + "' where id=" + num; 
			dbStatement.addEventListener(SQLEvent.RESULT, updateComplete);
			dbStatement.execute();
		}

		public function deleteData(id:Number):void
		{
			openConnection();
			dbStatement.text = "delete from mew_timing where id=" + id;
			dbStatement.addEventListener(SQLEvent.RESULT, deleteComplete);
			dbStatement.execute();
		}
		
		private function updateComplete(event : SQLEvent) : void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, updateComplete);
			var result:SQLResult = dbStatement.getResult();
			if(target){
				if(result) target.showLightAlert("更新成功!");
				else target.showLightAlert("更新失败!");
			}
			closeDB();
		}
		
		private function deleteComplete(event:SQLEvent):void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, deleteComplete);
			var result:SQLResult = dbStatement.getResult();
			if(target){
				if(result) target.showLightAlert("删除成功!");
				else target.showLightAlert("删除失败!");
			}
			closeDB();
		}

		private function dataReadComplete(event : SQLEvent) : void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, dataReadComplete);
			var dataVector:Vector.<TimingWeiboVariable> = new Vector.<TimingWeiboVariable>();
			var result:SQLResult = dbStatement.getResult();
			if(result.data){
				var len:int = result.data.length;
				for (var i : int = 0; i < len; i++) {
					var obj:Object = result.data[i];
					var timingWeibo:TimingWeiboVariable = new TimingWeiboVariable();
					timingWeibo.id = obj.id;
					timingWeibo.content = obj.content;
					timingWeibo.img = obj.img;
					timingWeibo.time = obj.time;
					timingWeibo.state = obj.state;
					timingWeibo.createTime = obj.createTime;
					dataVector.push(timingWeibo);
				}
				if(!isSelfReading) target.timingWeiboData(dataVector);
				else{
					timingWeiboList = dataVector;
					timingWeiboList.sort(sortByTime);
					startTiming();
					for each(var tm:TimingWeiboVariable in timingWeiboList){
						tm.toString();
					}
					trace("************************************************************************");
					trace(timingWeiboList.length + ">>>>>>");
				}
			}
			closeDB();
		}
	}
}