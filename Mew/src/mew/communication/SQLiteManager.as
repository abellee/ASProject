package mew.communication {
	import system.MewSystem;

	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogRelationshipDescriptor;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUsersRelationship;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.registerClassAlias;

	public class SQLiteManager
	{
		private var file:File = null;
		private var conn:SQLConnection = null;
		private var dbStatement:SQLStatement = null;
		private var needClose:Boolean = false;
		private var needReset:Boolean = false;
		public var cacheState:Boolean = false;
		
		public static const INSERT:String = "insert";
		public static const UPDATE:String = "update";
		public static const DELETE:String = "delete";
		public static const READ:String = "read";
		
		private var list:Array = ["mew_index", "mew_at", "mew_commentme", "mew_comment", "mew_dmsent", "mew_dmreceived", "mew_collect", "mew_fans", "mew_follow", "mew_user"];
		// {action:[]}
		private var queue:Object = {};
		private var index:int = 0;
		
		public function SQLiteManager()
		{
			registerClassAlias("microblogstatus", MicroBlogStatus);
			registerClassAlias("microbloguser", MicroBlogUser);
			registerClassAlias("microblogcomment", MicroBlogComment);
			registerClassAlias("microblogrelationshipdescriptor", MicroBlogRelationshipDescriptor);
			registerClassAlias("microblogdirectmessage", MicroBlogDirectMessage);
			registerClassAlias("microblogrelationship", MicroBlogUsersRelationship);
			registerClassAlias("microblogcount", MicroBlogCount);
			
			connectDB();
		}
		private function connectDB():void
		{
			needClose = false;
			file = File.applicationDirectory.resolvePath("mew.db");
			if(file.exists) needReset = true;
			else needReset = false;
			if(!conn) conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, connOpenHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, connOpenFailed);
			conn.openAsync(file);
		}
		private function connOpenFailed(event:SQLErrorEvent):void
		{
			trace(event.error.message + ">>>>>>" + event.error.details);
			conn.removeEventListener(SQLErrorEvent.ERROR, connOpenFailed);
			conn.removeEventListener(SQLEvent.OPEN, connOpenHandler);
		}
		private function connOpenHandler(event:SQLEvent):void
		{
			conn.removeEventListener(SQLErrorEvent.ERROR, connOpenFailed);
			conn.removeEventListener(SQLEvent.OPEN, connOpenHandler);
			trace("connected");
			if(!dbStatement) dbStatement = new SQLStatement();
			dbStatement.sqlConnection = conn;
			conn.attach("mew_index");
			conn.attach("mew_at");
			conn.attach("mew_commentme");
			conn.attach("mew_comment");
			conn.attach("mew_dmsent");
			conn.attach("mew_dmreceived");
			conn.attach("mew_collect");
			conn.attach("mew_fans");
			conn.attach("mew_follow");
			conn.attach("mew_user");
			if(needReset){
				deleteWeiboDB();
				needReset = false;
			}
		}
		private function checkTimingTable():void
		{
			var d:Date = new Date();
			var now:Number = d.time;
			dbStatement.text = "select * from mew_timing where userid=" + MewSystem.app.userData.id + " and time>=" + now + " and state = 0";
			dbStatement.addEventListener(SQLErrorEvent.ERROR, dbExecuteError);
			dbStatement.addEventListener(SQLEvent.RESULT, resultHandler);
			dbStatement.execute();
		}
		private function dbExecuteError(event:SQLErrorEvent):void
		{
			var details:String = event.error.details;
			dbStatement.removeEventListener(SQLEvent.RESULT, resultHandler);
			if(details.indexOf("no such table") != -1){
				createDB();
			}
		}
		private function resultHandler(event:SQLEvent):void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, resultHandler);
			var result:SQLResult = dbStatement.getResult();
			toManager(result);
			if(needClose) close();
		}
		private function deleteWeiboDB():void
		{
			conn.addEventListener(SQLEvent.BEGIN, beginTransaction);
			conn.begin();
		}
		private function beginTransaction(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.BEGIN, beginTransaction);
			conn.addEventListener(SQLEvent.COMMIT, deleteWeiboCommit);
			dropBatchDB();
		}
		private function dropBatchDB(event:SQLEvent=null):void
		{
			if(index >= list.length){
				dbStatement.removeEventListener(SQLEvent.RESULT, dropBatchDB);
				conn.commit();
				return;
			}
			if(!dbStatement.hasEventListener(SQLEvent.RESULT)) dbStatement.addEventListener(SQLEvent.RESULT, dropBatchDB);
			dbStatement.text = "drop table if exists " + list[index];
			index++;
			dbStatement.execute();
		}
		private function deleteWeiboCommit(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.COMMIT, deleteWeiboCommit);
			createWeiboDB();
		}
		private function createWeiboDB():void
		{
			index = 0;
			conn.addEventListener(SQLEvent.BEGIN, beginCreateTransaction);
			conn.begin();
		}
		private function beginCreateTransaction(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.BEGIN, beginCreateTransaction);
			conn.addEventListener(SQLEvent.COMMIT, createDBComplete);
			createBatchDB();
		}
		private function createDBComplete(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.COMMIT, createDBComplete);
		}
		private function createBatchDB(event:SQLEvent=null):void
		{
			if(index >= list.length){
				list = null;
				dbStatement.removeEventListener(SQLEvent.RESULT, createBatchDB);
				conn.commit();
				return;
			}
			if(!dbStatement.hasEventListener(SQLEvent.RESULT)) dbStatement.addEventListener(SQLEvent.RESULT, createBatchDB);
			dbStatement.text = "create table if not exists " + list[index] + "(" + 
				"id integer not null primary key autoincrement, " + 
				"sid text not null, " + 
				"content blob not null)";
			index++;
			dbStatement.execute();
		}
		private function createDB():void
		{
			dbStatement.text = "create table if not exists mew_timing(" +
				"id integer not null primary key autoincrement, " +
				"userid text not null, " +
				"content text not null, " +
				"img char, " +
				"time integer not null, " + 
				"state smallint not null default 0, " +
				"createTime integer not null)";
			dbStatement.addEventListener(SQLEvent.RESULT, createDBHandler);
			dbStatement.execute();
		}
		private function createDBHandler(event:SQLEvent):void
		{
			trace("db created!");
			dbStatement.removeEventListener(SQLEvent.RESULT, createDBHandler);
		}
		public function operation(action:String, statementArr:Array):void
		{
			if(!statementArr) throw new ArgumentError("you must specify the statement yourself for update db!");
			if(!queue[action]){
				queue[action] = [];
			}
			queue[action] = queue[action].concat(statementArr);
			checkContinue();
		}
		private function checkContinue():void
		{
			if(!dbStatement.executing){
				if(queue[INSERT] && queue[INSERT].length){
					cacheState = false;
					insert();
				}else if(queue[UPDATE] && queue[UPDATE].length){
					update();
				}else if(queue[DELETE] && queue[DELETE].length){
					remove();
				}else if(queue[READ] && queue[READ].length){
					if(cacheState) read();
				}
			}
		}
		private function insert():void
		{
			if(conn.inTransaction) return;
			list = queue[INSERT];
			conn.addEventListener(SQLEvent.BEGIN, beginInsertTransaction);
			conn.begin();
		}
		private function beginInsertTransaction(event:SQLEvent=null):void
		{
			if(!queue[INSERT] || queue[INSERT].length <= 0){
				dbStatement.removeEventListener(SQLEvent.RESULT, beginInsertTransaction);
				conn.removeEventListener(SQLEvent.BEGIN, beginInsertTransaction);
				conn.addEventListener(SQLEvent.COMMIT, nextInsertTransaction);
				conn.commit();
				return;
			}
			if(!dbStatement.hasEventListener(SQLEvent.RESULT)) dbStatement.addEventListener(SQLEvent.RESULT, beginInsertTransaction);
			var state:* = list[0];
			if(state is Array){
				dbStatement.text = state[0];
				dbStatement.parameters[state[1]] = state[2];
			}else if(state is String){
				dbStatement.text = state;
			}
			queue[INSERT].shift();
			dbStatement.execute();
		}
		private function nextInsertTransaction(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.COMMIT, nextInsertTransaction);
			if(queue[INSERT].length){
				insert();
			}else{
				cacheState = true;
				checkContinue();
			}
		}
		private function insertDataHandler(event:SQLEvent):void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, insertDataHandler);
			trace("insert success!");
		}
		private function remove():void
		{
			dbStatement.addEventListener(SQLEvent.RESULT, deleteDataHandler);
			dbStatement.text = queue[DELETE][0];
			delete queue[DELETE];
			dbStatement.execute();
		}
		private function deleteDataHandler(event:SQLEvent):void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, deleteDataHandler);
			checkContinue();
		}
		private function update():void
		{
			dbStatement.addEventListener(SQLEvent.RESULT, updateDataHandler);
			dbStatement.text = queue[UPDATE][0];
			delete queue[UPDATE];
			dbStatement.execute();
		}
		private function updateDataHandler(event:SQLEvent):void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, updateDataHandler);
			checkContinue();
		}
		private function read():void
		{
			dbStatement.addEventListener(SQLEvent.RESULT, readDataHandler);
			dbStatement.clearParameters();
			dbStatement.text = queue[READ][0];
			delete queue[READ];
			dbStatement.execute();
		}
		private function readDataHandler(event:SQLEvent):void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, readDataHandler);
			checkContinue();
			var result:SQLResult = dbStatement.getResult();
			MewSystem.app.callFromSQLiteManager(result.data);
		}
		private function toManager(result:SQLResult):void
		{
			if(result.data && result.data.length){
//				if(!MewSystem.app.timingWeiboManager) MewSystem.app.timingWeiboManager = new TimingWeiboManager();
//				MewSystem.app.timingWeiboManager.data = result.data;
			}
		}
		public function close():void
		{
			if(dbStatement){
				if(dbStatement.executing) needClose = true;
				else{
					conn.close();
					dbStatement.removeEventListener(SQLErrorEvent.ERROR, dbExecuteError);
					dbStatement.sqlConnection = null;
					conn = null;
					dbStatement = null;
					file = null;
				}
			}
		}
	}
}