package mew.modules
{
	import flash.utils.ByteArray;
	
	import mew.data.UserData;
	import mew.data.WeiboData;

	public interface IWeiboPublisherContainer extends IDisplay
	{
		function showWeiboContent(state:String, userData:UserData, weiboData:WeiboData):void;
		function getContent():String;
		function getImageData():ByteArray;
		function getReplyId():String;
		function isComment():int;
		function getCommentId():String;
		function resetContent(removeImage:Boolean = true):void;
	}
}