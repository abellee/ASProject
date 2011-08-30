package mew.modules
{
	public interface ISystemSettingContainer extends IDisplay
	{
		function init():void;
		function setDefault():void;
		function setSize(w:Number, h:Number, color:Number = 0):void;
		
		function get hideDir():int;
		function get updateDelay():int;
		function get isVoice():Boolean;
		function get isAutoRun():Boolean;
		function get isAutoHide():Boolean;
		function get isWBNotice():Boolean;
		function get isAtNotice():Boolean;
		function get isDMNotice():Boolean;
		function get isAutoLogin():Boolean;
		function get alwaysInFront():Boolean;
		function get isFansComment():Boolean;
		function get isCommentNotice():Boolean;
	}
}