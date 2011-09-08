package mew.modules
{
	import flash.utils.ByteArray;
	
	import mew.data.UserData;
	import mew.data.WeiboData;

	public interface IWeiboPublisherContainer extends IDisplay
	{
		function showWeiboContent(state:String, userData:UserData, weiboData:WeiboData, repostUserData:UserData, repostData:WeiboData, additionStr:String):void;
		function getContent():String;
		function getImageData():ByteArray;
		function resetContent(removeImage:Boolean = true):void;
		function getFirstSelect():Boolean;
		function getSecondSelect():Boolean;
		function hasFirstCheckBox():Boolean;
		function hasSecondCheckBox():Boolean;
		function getUserData():UserData;
		function getRepostUserData():UserData;
		function getWeiboData():WeiboData;
		function getRepostData():WeiboData;
	}
}