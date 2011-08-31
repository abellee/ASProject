package mew.cache {
	import config.SQLConfig;

	import system.MewSystem;

	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogRelationshipDescriptor;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUsersRelationship;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;

	public class WeiboDataCacher
	{
//		private var lastWriteID:String = null;                          // 最后一次写操作的数据id
		
		public function WeiboDataCacher()
		{
			registerClassAlias("microblogstatus", MicroBlogStatus);
			registerClassAlias("microbloguser", MicroBlogUser);
			registerClassAlias("microblogcomment", MicroBlogComment);
			registerClassAlias("microblogrelationshipdescriptor", MicroBlogRelationshipDescriptor);
			registerClassAlias("microblogdirectmessage", MicroBlogDirectMessage);
			registerClassAlias("microblogrelationship", MicroBlogUsersRelationship);
			registerClassAlias("microblogcount", MicroBlogCount);
		}
		public function writeData(obj:Object):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("cache/" + MewSystem.app.userData.id + "/" + obj["fileName"] + ".cache");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(obj["data"]);
			fileStream.close();
		}
		public function appendData():void
		{
			
		}
		public function readData(fileName:String):void
		{
			var arr:Array;
			if(fileName == SQLConfig.MEW_DIRECT){
				var receivedArray:Array = readLocalData("mew_dmreceived");
				var sentArray:Array = readLocalData("mew_dmsent");
				arr = receivedArray.concat(sentArray);
				arr.sortOn("id", Array.DESCENDING);
				MewSystem.app.callFromSQLiteManager(arr);
				return;
			}
			arr = readLocalData(fileName);
			MewSystem.app.callFromSQLiteManager(arr);
		}
		private function readLocalData(fileName:String):Array
		{
			var file:File = File.applicationStorageDirectory.resolvePath("cache/" + MewSystem.app.userData.id + "/" + fileName + ".cache");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var obj:Object = fileStream.readObject();
			fileStream.close();
			var arr:Array = [];
			for(var key:String in obj){
				arr.push(obj[key]);
				delete obj[key];
			}
			arr.sortOn("id", Array.DESCENDING);
			return arr;
		}
		public function updateData():void
		{
			
		}
		public function deleteData():void
		{
			
		}
	}
}