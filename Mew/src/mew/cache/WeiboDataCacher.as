package mew.cache {
	import config.SQLConfig;

	import system.MewSystem;

	import com.adobe.images.JPGEncoder;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogRelationshipDescriptor;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUsersRelationship;

	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

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
		
		public function writeData(arr:Array, fileName:String):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("cache/" + MewSystem.app.userData.id + "/" + fileName + ".cache");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(arr);
			fileStream.close();
		}
		
		public function appendData(arr:Array, fileName:String):void
		{
			var result:Array = readLocalData(fileName);
			result = result.concat(arr);
			MewSystem.setFinalId(fileName, result);
			writeData(result, fileName);
		}
		
		public function prefixData(arr:Array, fileName:String, limitNum:int):void
		{
			trace(arr.length, "prefixData");
			var result:Array = readLocalData(fileName);
			var num:int = arr.length;
			for (var i : int = 0; i < num; i++) result.pop();
			arr = arr.concat(result);
			trace(arr.length, result.length);
			MewSystem.setLastId(fileName, arr);
			writeData(arr, fileName);
		}
		
		public function readData(fileName:String):void
		{
			var arr:Array;
			arr = readLocalData(fileName);
			MewSystem.app.callFromSQLiteManager(arr);
		}
		private function readLocalData(fileName:String):Array
		{
			var file:File = File.applicationStorageDirectory.resolvePath("cache/" + MewSystem.app.userData.id + "/" + fileName + ".cache");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var arr:Array = fileStream.readObject();
			fileStream.close();
//			for(var key:String in obj){
//				arr.push(obj[key]);
//				delete obj[key];
//			}
//			arr.sortOn("id", Array.DESCENDING);
			return arr;
		}
		public function updateData():void
		{
			
		}
		public function deleteData(fileName:String, index:int):void
		{
			var arr:Array = readLocalData(fileName);
			if(index <= arr.length){
				arr.splice(index, 1);
				writeData(arr, fileName);
				if(!index) MewSystem.setLastId(fileName, arr);
			}
		}
		
		public function writeUserBitmap(id:String, bitmapData:BitmapData):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("cache/" + id + ".jpg");
			if(!file.exists){
				var encoder:JPGEncoder = new JPGEncoder(50);
				var bytes:ByteArray = encoder.encode(bitmapData);
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeBytes(bytes);
				fileStream.close();
			}
		}
	}
}